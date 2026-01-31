class Stream:
    def __init__(self, kernel):
        self.kernel = kernel
        self.pc = 0

    def next(self):
        if self.pc >= len(self.kernel.instructions):
            return None
        instr = self.kernel.instructions[self.pc]
        self.pc += 1
        return instr
