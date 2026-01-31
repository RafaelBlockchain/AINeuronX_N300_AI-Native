class Instruction:
    def __init__(self, opcode, dst=None, src=None, imm=None):
        self.opcode = opcode
        self.dst = dst
        self.src = src
        self.imm = imm
        self.issued = False
        self.remaining_cycles = 0
