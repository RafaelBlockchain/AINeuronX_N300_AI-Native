class FeedbackTuner:
    def __init__(self):
        self.state = {}

    def apply(self, decision):
        action = decision["action"]

        if action == "reduce_tile_k":
            self.state["K_DIM"] = "smaller"
        elif action == "maximize_tile":
            self.state["K_DIM"] = "max"
        elif action == "vector_fusion":
            self.state["vector_fuse"] = True

        return self.state
