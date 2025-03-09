import numpy as np
import os
import sys

def main():
    # Seed the random number generator for reproducibility
    np.random.seed(4894)
    
    # Define file names
    checkpoint_file = 'software/checkpoint.npz'
    w_mat_file = 'testbench/W_mat.txt'
    x_mat_file = 'testbench/X_mat.txt'

    # Define matrix dimensions
    # Modify these values as needed
    k = 4  # Number of rows in X
    n = 2  # Number of columns in X and size of W (n x n)

    # Validate that k >= n
    if k < n:
        raise ValueError(f"The number of rows in X (k) must be greater than or equal to n.")

    # Initialize variables
    X = None
    W = None
    checkpoint_exists = os.path.isfile(checkpoint_file)

    if checkpoint_exists:
        print(f"Loading matrices from checkpoint '{checkpoint_file}'...")
        try:
            data = np.load(checkpoint_file)
            X_loaded = data['X']
            W_loaded = data['W']
            
            # Verify dimensions
            if X_loaded.shape != (k, n):
                print(f"Error: Loaded X matrix shape {X_loaded.shape} does not match expected shape ({k}, {n}).")
                print("Please delete the existing checkpoint and rerun the script.")
                sys.exit(1)
            if W_loaded.shape != (n, n):
                print(f"Error: Loaded W matrix shape {W_loaded.shape} does not match expected shape ({n}, {n}).")
                print("Please delete the existing checkpoint and rerun the script.")
                sys.exit(1)
            
            X = X_loaded
            W = W_loaded
            print("Successfully loaded matrices from checkpoint.\n")
        except Exception as e:
            print(f"Error loading checkpoint: {e}")
            sys.exit(1)
    else:
        print("Checkpoint not found. Generating new matrices...\n")
        # Generate X matrix (k x n) with random integers
        X = np.random.randint(-4096, 4096, size=(k, n))
        print(f"Generated X matrix ({k}x{n}):")
        print(X, "\n")

        # Generate W matrix (n x n) with ternary weights {-1, 0, +1}
        W = np.random.choice([-1, 0, 1], size=(n, n))
        print(f"Generated W matrix ({n}x{n}):")
        print(W, "\n")

    # If matrices were loaded, print them
    if checkpoint_exists:
        print(f"Loaded X matrix ({k}x{n}):")
        print(X, "\n")
        print(f"Loaded W matrix ({n}x{n}):")
        print(W, "\n")

    # Arrange X matrix and W matrix
    # The arrangement logic places each X[i, j] at position (i + j, i) in arranged_X

    arranged_X = np.concatenate([X, np.zeros((k, k-1))], axis=1).T
    arranged_W = np.concatenate([W, np.zeros((n, n-1))], axis=1)

    # If checkpoint did not exist, save arranged matrices and checkpoint
    if not checkpoint_exists:
        print("Saving arranged matrices to text files...\n")
        # Ensure the directories exist
        os.makedirs(os.path.dirname(w_mat_file), exist_ok=True)
        os.makedirs(os.path.dirname(x_mat_file), exist_ok=True)

        # Save W matrix
        try:
            np.savetxt(w_mat_file, arranged_W, fmt='%d', delimiter=' ')
            print(f"Saved arranged W matrix to '{w_mat_file}':")
            print(arranged_W, "\n")
        except Exception as e:
            print(f"Error saving W matrix: {e}")
            sys.exit(1)

        # Save X matrix
        try:
            np.savetxt(x_mat_file, arranged_X, fmt='%d', delimiter=' ')
            print(f"Saved arranged X matrix to '{x_mat_file}':")
            print(arranged_X, "\n")
        except Exception as e:
            print(f"Error saving X matrix: {e}")
            sys.exit(1)

        # Save checkpoint
        print("Saving matrices to checkpoint...\n")
        os.makedirs(os.path.dirname(checkpoint_file), exist_ok=True)
        try:
            np.savez(checkpoint_file, X=X, W=W)
            print(f"Saved checkpoint to '{checkpoint_file}'.\n")
        except Exception as e:
            print(f"Error saving checkpoint: {e}")
            sys.exit(1)
    else:
        print("Matrices were loaded from checkpoint; no need to save again.\n")

    # Compute Y = X * W
    Y = X @ W

    # Print the matrices
    print("Final Matrices:")
    print("W_mat:")
    print(W, "\n")
    print("X_mat:")
    print(X, "\n")
    print("Y_mat (Y = X * W):")
    print(Y, "\n")

if __name__ == "__main__":
    main()
