class Scoreboard:
    def __init__(self, reg_count):
        self.reg_busy = [False] * reg_count
        self.vector_busy = False
        self.tensor_busy = False
        self.dma_busy = False

    def can_issue(self, instr):
        if instr.opcode.name.startswith("T_") and self.tensor_busy:
            return False
        if instr.opcode.name.startswith("V_") and self.vector_busy:
            return False
        if instr.opcode.name.startswith("DMA") and self.dma_busy:
            return False
        return True
