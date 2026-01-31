class Mapper:
    def __init__(self, fabric):
        self.fabric = fabric

    def map(self, instr):
        # v0: round-robin simple
        return self.fabric.next_tile()
