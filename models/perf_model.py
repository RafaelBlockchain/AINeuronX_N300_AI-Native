class PerfModel:
    def __init__(
        self,
        rows=4,
        cols=4,
        lanes=4,
        freq_hz=1e9
    ):
        self.rows = rows
        self.cols = cols
        self.lanes = lanes
        self.freq_hz = freq_hz

    # ===============================
    # Tensor (systolic)
    # ===============================
    def tensor_cycles(self, M, N, K):
        # output-stationary systolic
        # ciclos ≈ K + ROWS + COLS
        wavefront = self.rows + self.cols
        return K + wavefront

    def tensor_ops(self, M, N, K):
        return 2 * M * N * K  # MACs

    def tensor_tops(self, M, N, K):
        ops = self.tensor_ops(M, N, K)
        cycles = self.tensor_cycles(M, N, K)
        time_s = cycles / self.freq_hz
        return ops / time_s / 1e12

    # ===============================
    # Vector
    # ===============================
    def vector_cycles(self, elements):
        # 1 ciclo por operación vectorial
        return (elements + self.lanes - 1) // self.lanes

    def vector_ops(self, elements):
        return elements

    def vector_gops(self, elements):
        ops = self.vector_ops(elements)
        cycles = self.vector_cycles(elements)
        time_s = cycles / self.freq_hz
        return ops / time_s / 1e9

    # ===============================
    # Summary
    # ===============================
    def summary(self, M, N, K, vec_elements):
        return {
            "tensor_TOPS": self.tensor_tops(M, N, K),
            "vector_GOPS": self.vector_gops(vec_elements),
            "tensor_cycles": self.tensor_cycles(M, N, K),
            "vector_cycles": self.vector_cycles(vec_elements),
        }
