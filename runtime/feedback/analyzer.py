from models.perf_model import PerfModel
from models.roofline import RooflineModel

class FeedbackAnalyzer:
    def __init__(self, hw_cfg, mem_bw_gbs):
        self.perf = PerfModel(
            rows=hw_cfg["rows"],
            cols=hw_cfg["cols"],
            lanes=hw_cfg["lanes"],
            freq_hz=hw_cfg["freq_hz"]
        )
        self.roof = RooflineModel(
            peak_tops=hw_cfg["peak_tops"],
            mem_bw_gbs=mem_bw_gbs
        )

    def analyze_tensor(self, M, N, K, bytes_moved):
        perf = self.perf.summary(M, N, K, vec_elements=0)
        roof = self.roof.point(
            flops=2 * M * N * K,
            bytes_moved=bytes_moved
        )

        return {
            "mode": "tensor",
            "tensor_TOPS": perf["tensor_TOPS"],
            "cycles": perf["tensor_cycles"],
            "roof_intensity": roof["intensity"],
            "roof_attainable_TOPS": roof["attainable_TOPS"],
            "bound": "memory" if roof["attainable_TOPS"] < perf["tensor_TOPS"] else "compute"
        }

    def analyze_vector(self, elements):
        perf = self.perf.summary(M=0, N=0, K=0, vec_elements=elements)
        return {
            "mode": "vector",
            "vector_GOPS": perf["vector_GOPS"],
            "cycles": perf["vector_cycles"]
        }
