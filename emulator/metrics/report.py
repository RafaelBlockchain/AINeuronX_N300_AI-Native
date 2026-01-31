class Report:
    def __init__(self, counters):
        self.counters = counters

    def dump(self):
        return {
            "instructions_executed": self.counters.exec
        }
