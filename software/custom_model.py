import torch
from torch import nn 
from torch.nn import functional as F
from itertools import chain
from layers import MatMulFreeModel
from mmfreelm.ops.fusedbitnet import FusedBitLinear as BitLinear

from torch.utils.data import DataLoader, Dataset
from tokenizers import Tokenizer, normalizers, models, trainers, pre_tokenizers, decoders, processors
from transformers import PreTrainedTokenizerFast
from datasets import load_dataset, Dataset as HFDataset


class EarlyStopping(Exception): pass



class MatMulFreeLM(nn.Module):
    def __init__(self,
                 embedding_dim,
                 vocab_size,
                 seq_len,
                 n_layer=1,
                 n_head=1):
        super().__init__()
        self.seq_len = seq_len
        self.n_layer, self.n_head, self.embedding_dim = n_layer, n_head, embedding_dim
        self.vocab_size = vocab_size
        self.seq_len = seq_len
        self.transformer = MatMulFreeModel(self.n_layer,
                                       self.n_head,
                                       self.embedding_dim,
                                       self.vocab_size,
                                       self.seq_len)
        
        self.head = BitLinear(self.embedding_dim, self.vocab_size, bias=False)

        self.apply(self._init_weights)

    def _init_weights(self, module):
        if isinstance(module, nn.Linear):
            torch.nn.init.normal_(module.weight, mean=0.0, std=0.02)
            if module.bias is not None:
                torch.nn.init.zeros_(module.bias)
        elif isinstance(module, nn.LayerNorm):
            torch.nn.init.zeros_(module.bias)
            module.weight.data.fill_(1.0)
        elif isinstance(module, nn.Embedding):
            torch.nn.init.normal_(module.weight, mean=0.0, std=0.02)


    def forward(self, inputs, target=None):
        x = self.transformer(inputs)
        logits = self.head(x)
        if target is None:
            return logits, None
        else:
            loss = F.cross_entropy(logits.view(-1, logits.size(-1)), target.view(-1))
            return logits, loss

    def generate(self,
                 inputs,
                 required_chars, 
                 sampling=False,
                 top_k=None):
        with torch.inference_mode():
            for _ in range(required_chars): #tokens actually, but the datasets are chars
                logits = self(inputs[:, -self.seq_len:])[0][:, -1, :]
                if top_k: #only consider top k candidates
                    top_vals, _ = torch.topk(logits, top_k)
                    logits[logits < top_vals[:, -1]] = -float('Inf')
                probs = F.softmax(logits, dim=-1)
                if sampling:
                    next_char = torch.multinomial(probs, num_samples=1)
                else:
                    _, next_char = torch.topk(probs, k=1, dim=-1)
                inputs = torch.cat((inputs, next_char), dim=1)
        return inputs


class Trainer:
    def __init__(self, model, 
                 dataset, 
                 tokenizer,
                 learning_rate,
                 batch_size=64,
                 max_iters=50000,
                 patience=float('inf'),
                 log_interval=500):
        self.model = model
        self.dataset = dataset
        self.tokenizer = tokenizer
        self.patience = patience  # Number of epochs to wait for improvement

        self.device = 'cuda' if torch.cuda.is_available() else 'cpu'
        print(f"running on {self.device}")

        self.batch_size = batch_size
        self.max_iters = max_iters
        self.learning_rate = learning_rate
        decay, no_decay = [], []
        for name, param in self.model.named_parameters():
            if any(key in name for key in ['emb', 'pos', 'ln', 'bias']):
                no_decay.append(param)
            else:
                decay.append(param)
        self.optimizer = torch.optim.AdamW(
                                            # [{"params": decay, "weight_decay": 0.1},
                                            # {"params": no_decay, "weight_decay": 0.0}],
                                            self.model.parameters(), 
                                            lr=self.learning_rate)
        self.log_interval = log_interval


    def run(self, type):
        assert type in ['multiplication', 'story']
        num_workers = 0
        train_loader = DataLoader(
            self.dataset,
            shuffle=True,
            pin_memory=True,
            batch_size=self.batch_size,
            num_workers=num_workers,
            persistent_workers=num_workers > 0,
        )

        self.model = self.model.to(self.device)
        self.model.train()
        self.iter_num = 0
        self.train_losses = []
        self.best_loss = float('inf')
        self.epochs_no_improve = 0
        data_iter = iter(train_loader)
        
        for _ in range(self.max_iters):
            try:
                x, y = next(data_iter)
            except StopIteration:
                data_iter = iter(train_loader)
                x, y = next(data_iter)
            x, y = x.to(self.device, non_blocking=True), y.to(self.device, non_blocking=True) # x: input, y: target
            ###########################################################################
            # TODO: Train self.model on the sampled batch in PyTorch                  #
            # Hint: 1. Zero the gradients of self.model, with set_to_none=True        #
            #       2. Calculate loss given input x and target y                      #
            #       3. Compute gradients from loss                                    #
            #       4. Clip the gradient norm with                                    #
            #           torch.nn.utils.clip_grad_norm_(self.model.parameters(), 1.0)  #
            #       5. Perform an optimization step on self.optimizer                 #
            ###########################################################################
            self.optimizer.zero_grad(set_to_none=True)
            _, loss = self.model(x, y)
            loss.backward()
            torch.nn.utils.clip_grad_norm_(self.model.parameters(), 1.0)
            self.optimizer.step()
            ###########################################################################
            #                             END OF YOUR CODE                            #
            ###########################################################################
            try:
                self.train_log(loss, type)
            except EarlyStopping:
                break
            self.iter_num += 1

    def generate(self):
        self.model.eval()
        contexts = ["Once upon a time",
                    "Once there was an ",
                    "One day"]
        for i in range(3):
            x = torch.tensor(self.tokenizer.encode(contexts[i])).long()[None,...]
            y = self.model.generate(x.to(self.device), 
                                    1024, 
                                    sampling=True, 
                                    top_k=10)[0]
            story = ''.join(self.tokenizer.decode(y.tolist()))
            story = story.split('<|endoftext|>')[0]
            print(f"Story ({i+1}): \n{story}")   

    def train_log(self, loss, type):
        self.train_losses.append(loss.item())
        self.model.eval() #set model to eval mode
        if (self.iter_num % self.log_interval == 0) or ((self.iter_num+1) >= self.max_iters):            
            print(f"Iteration {self.iter_num+1}/{self.max_iters}: training loss {loss.item():.4f}")

            # Early stopping check
            if loss.item() < self.best_loss:
                self.best_loss = loss.item()
                self.epochs_no_improve = 0
            else:
                self.epochs_no_improve += 1

            if self.epochs_no_improve >= self.patience:
                raise EarlyStopping("Early stopping triggered")
            
            if type == 'multiplication':
                Evaluator(self.dataset, self.model, 'train').eval_split(self.device)
            elif type == 'story':
                contexts = ["Once upon a time",
                            "Once there was an ",
                            "One day"]
                for i in range(3):
                    with torch.inference_mode():
                        x = torch.tensor(self.tokenizer.encode(contexts[i])).long()[None,...]
                        y = self.model.generate(x.to(self.device), 
                                                1024, 
                                                sampling=True, 
                                                top_k=10)[0]
                    story = ''.join(self.tokenizer.decode(y.tolist()))
                    story = story.split('<|endoftext|>')[0]
                    print(f"Story ({i+1}): \n{story}")
        self.model.train()

class Evaluator:
    def __init__(self, dataset, model, split):
        self.model = model
        self.dataset = dataset
        self.split = split

    def eval_split(self, print_example=0):
        device = 'cuda' if torch.cuda.is_available() else 'cpu'
        self.model = self.model.to(device)
        n = self.dataset.n
        results, all_preds = [], []
        
        loader = DataLoader(self.dataset, 
                            batch_size=64, 
                            num_workers=12,
                            pin_memory=True, 
                            shuffle=True,
                            drop_last=False)
        for x, _ in loader:
            B = x.size(0)
            ab = x[:, :n*2].to(device)
            abc = self.model.generate(ab, 2*n)
            a, b = self.dataset.str_to_digit(ab[:,:n], device), self.dataset.str_to_digit(ab[:,n:n*2], device)
            c_gt = a * b
            c_pred = self.dataset.str_to_digit(abc[:, -(2*n):].flip(1), device)
            all_correct = (c_pred == c_gt).cpu()

            for i in range(B): #batch
                results.append(int(all_correct[i]))
                all_preds.append((a[i], b[i], c_pred[i], c_gt[i]))

        print(f'{self.split} accuracy: {100*sum(results)/len(results):.2f}%')
        for (a[i], b[i], c_pred[i], c_gt[i]) in all_preds[:print_example]:
            print(f"Prediction: {a[i]} x {b[i]} = {c_pred[i]}, correct answer: {c_gt[i]}")

def get_tokenization(vocab_size, seq_len):
    try:
        tokenizer = PreTrainedTokenizerFast(tokenizer_file="tokenizer.json")
        tokenized_dataset = HFDataset.load_from_disk('./tokenized_dataset')
    except:
        dataset = load_dataset('roneneldan/TinyStories', split='validation')
        
        def get_texts(dataset):
            return [item['text'] for item in dataset]

        texts = get_texts(dataset)

        # Train BPE Tokenizer
        tokenizer = Tokenizer(models.BPE(unk_token="<unk>"))
        tokenizer.pre_tokenizer = pre_tokenizers.ByteLevel(add_prefix_space=False)
        tokenizer.post_processor = processors.ByteLevel(trim_offsets=False)
        tokenizer.decoder = decoders.ByteLevel()
        tokenizer.normalizer = normalizers.BertNormalizer(True, strip_accents=True, lowercase=True)
        trainer = trainers.BpeTrainer(
            vocab_size=vocab_size,
            special_tokens=['<unk>'],
            limit_alphabet=vocab_size - 1,
        )        
        tokenizer.train_from_iterator(texts, trainer)
        tokenizer.save("tokenizer.json")
        tokenizer = PreTrainedTokenizerFast(tokenizer_object=tokenizer)



        # Tokenize Dataset
        def tokenize_function(examples):
            examples['input_ids'] = [tokenizer.encode(text) for text in examples['text']]
            return examples

        tokenized_dataset = dataset.map(tokenize_function, batched=True)

        
        flattened_input_ids = list(chain.from_iterable(tokenized_dataset['input_ids']))
        tokenized_dataset = HFDataset.from_dict({'input_ids': flattened_input_ids})        
        tokenized_dataset.save_to_disk('./tokenized_dataset')

    return tokenizer, StoryDataset(tokenized_dataset, vocab_size, seq_len)


class StoryDataset(Dataset):
    def __init__(self, tokenized_dataset, vocab_size, seq_len):
        self.seq_len = seq_len
        self.tokenized_dataset = tokenized_dataset['input_ids']
        self.data_size = len(self.tokenized_dataset)
        self.vocab_size = vocab_size
        
    def get_seq_len(self):
        return self.seq_len
        
    def __len__(self):
        return self.data_size - self.seq_len - 1
        
    def __getitem__(self, idx):
        seq = self.tokenized_dataset[idx:idx+self.seq_len + 1]
        x = torch.tensor(seq[:-1]).long()
        y = torch.tensor(seq[1:]).long()
        return x, y