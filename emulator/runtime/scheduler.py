class Scheduler:
    def __init__(self):
        self.policies = {}

    def apply_policies(self, policies):
        self.policies = policies

    def schedule(self, streams):
        ordered = []

        for s in streams:
            tid = s.target_tile
            if self.policies.get(tid) == "DEPRIORITIZE":
                continue
            ordered.append(s)

        return ordered

