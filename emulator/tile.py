class Tile:
    def __init__(self, tile_id, program, ssb, dma_engine, logger):
        self.tile_id = tile_id
        self.program = program
        self.ssb = ssb
        self.dma_engine = dma_engine
        self.logger = logger

        self.pc = 0
        self.current = None

    def step(self, cycle):
        if self.pc < len(self.program):
            instr = self.program[self.pc]
            self.current = instr

            self.logger.log({
                "cycle": cycle,
                "opcode": instr["opcode"],
                "event": "COMMIT",
            })

            self.pc += 1
        else:
            self.current = None

