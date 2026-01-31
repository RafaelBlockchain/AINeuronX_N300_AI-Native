import numpy as np

def generate_heatmap(matrix):
    matrix = np.array(matrix)
    min_val = matrix.min()
    max_val = matrix.max()

    if max_val == min_val:
        return np.zeros_like(matrix)

    return (matrix - min_val) / (max_val - min_val)


if __name__ == "__main__":
    sample = [[1, 2, 3],
              [4, 5, 6],
              [7, 8, 9]]
    print(generate_heatmap(sample))
