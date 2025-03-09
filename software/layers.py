import torch
from torch import nn
import numpy as np
from mmfreelm.layers import HGRNBitAttention
from mmfreelm.modules import RMSNorm
from time import perf_counter

class Block(nn.Module):
    def __init__(self, hidden_size, n_head, seq_len):
        super().__init__()
        self.attn = HGRNBitAttention(hidden_size=hidden_size, num_heads=n_head)


    def forward(self, x):
        t0 = perf_counter()
        x = self.attn(x)[0]
        t1 = perf_counter()
        return x


class MatMulFreeModel(nn.Module):
    def __init__(self, n_layer, n_head, embedding_dim, vocab_size, seq_len):
        super().__init__()
        self.emb = nn.Embedding(vocab_size, embedding_dim)
        # self.pos = nn.Embedding(seq_len, embedding_dim)
        self.attention = nn.ModuleList([Block(hidden_size=embedding_dim, n_head=n_head, seq_len=seq_len) for _ in range(n_layer)])
        self.ln = RMSNorm(embedding_dim)
    def forward(self, x):
        _, t = x.size()
        pos = torch.arange(0, t).unsqueeze(0).long().to(x.device)
        tok_emb = self.emb(x)
        # pos_emb = self.pos(pos)
        x = tok_emb #+ pos_emb
        for block in self.attention:
            x = block(x)
        x = self.ln(x)
        return x


def q(x, N, R):
    """
    Quantize a vector or matrix of floating point numbers into fixed-point (N, R) representation.

    Args:
        x (array_like): Input floating point vector or matrix.
        N (int): Number of mantissa bits.
        R (int): Number of exponent bits.

    Returns:
        np.ndarray: Quantized mantissa as an integer array with the same shape as `x`.
    """
    # Convert input to a NumPy array for vectorized operations
    x = np.asarray(x)
    
    # Calculate the scaling factor based on the number of exponent bits
    scaling_factor = 2 ** R
    
    # Scale and floor the input values to obtain the mantissa
    mantissa = np.floor(x * scaling_factor)
    
    # Define the maximum and minimum mantissa values based on mantissa bits
    max_mantissa = 2 ** (N - 1) - 1
    min_mantissa = -2 ** (N - 1)
    
    # Clamp the mantissa values to lie within [min_mantissa, max_mantissa]
    mantissa = np.clip(mantissa, min_mantissa, max_mantissa)
    
    # Convert the mantissa to 64-bit integers
    mantissa = mantissa.astype(int)
    
    return mantissa
