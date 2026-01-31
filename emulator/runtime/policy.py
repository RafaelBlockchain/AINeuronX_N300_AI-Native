class PolicyEngine:
    def decide(self, metrics):
        decisions = {}

        for tid, m in metrics.items():
            if m.stall > 100:
                decisions[tid] = "DEPRIORITIZE"
            elif m.route > m.instr:
                decisions[tid] = "LIMIT_ROUTE"
            else:
                decisions[tid] = "BOOST"

        return decisions
