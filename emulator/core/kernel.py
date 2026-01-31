from .isa import Instruction

class Kernel:
    def __init__(self, name):
        self.name = name
        self.instructions: list[Instruction] = []

    def emit(self, instr: Instruction):
        self.instructions.append(instr)

    def __iter__(self):
        return iter(self.instructions)
