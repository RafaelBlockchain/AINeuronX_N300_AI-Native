class AdaptivePolicy:
    def __init__(self):
        pass

    def decide(self, analysis):
        if analysis["mode"] == "tensor":
            if analysis["bound"] == "memory":
                return {
                    "action": "reduce_tile_k",
                    "reason": "memory_bound"
                }
            else:
                return {
                    "action": "maximize_tile",
                    "reason": "compute_bound"
                }

        if analysis["mode"] == "vector":
            return {
                "action": "vector_fusion",
                "reason": "low_latency_path"
            }

        return {"action": "noop"}
