from emulator.core.state import TileState
from emulator.core.isa import LATENCY_TABLE
from emulator.memory.dma import DMARequest

class Tile:
    def __init__(self, tile_id, program, scoreboard, dma_engine, logger):
        self.id = tile_id
        self.program = program
        self.scoreboard = scoreboard
        self.dma_engine = dma_engine
        self.logger = logger

        self.pc = 0
        self.state = TileState.IDLE
        self.current = None
        self.remaining = 0

    def can_issue(self):
        return self.current is None and self.pc < len(self.program)

    def issue(self, cycle):
        instr = self.program[self.pc]

        if not self.scoreboard.can_issue(instr):
            self.state = TileState.STALLED
            return None

        name = instr.opcode.name

        # SCALAR
        if name.startswith("SC_"):
            self.remaining = LATENCY_TABLE["SCALAR"]
            self.state = TileState.EXEC_SCALAR

        # VECTOR
        elif name.startswith("V_"):
            self.remaining = LATENCY_TABLE["VECTOR"]
            self.scoreboard.vector_busy = True
            self.state = TileState.EXEC_VECTOR

        # TENSOR
        elif name.startswith("T_"):
            self.remaining = LATENCY_TABLE[name]
            self.scoreboard.tensor_busy = True
            self.state = TileState.EXEC_TENSOR

        # DMA
        elif name.startswith("DMA_"):
            latency = LATENCY_TABLE["DMA"]
            req = DMARequest(self.id, instr.dst, instr.imm, latency)
            self.dma_engine.start(req)
            self.scoreboard.dma_busy = True
            self.state = TileState.WAIT_DMA
            self.logger.log(cycle, self.id, "DMA_START", name)
            self.current = instr
            self.pc += 1
            return instr

        self.current = instr
        self.pc += 1
        self.logger.log(cycle, self.id, "ISSUE", name)
        return instr

    def step(self, cycle):
        if self.state == TileState.WAIT_DMA:
            if self.dma_engine.is_done(self.id):
                self.dma_engine.clear_done(self.id)
                self.scoreboard.dma_busy = False
                finished = self.current
                self.current = None
                self.state = TileState.IDLE
                self.logger.log(cycle, self.id, "DMA_DONE", None)
                self.logger.log(cycle, self.id, "COMMIT", finished.opcode.name)
                return finished
            return None

        if self.current is None:
            return None

        self.remaining -= 1
        if self.remaining <= 0:
            finished = self.current
            self._release_resources(finished)
            self.current = None
            self.state = TileState.IDLE
            self.logger.log(cycle, self.id, "COMMIT", finished.opcode.name)
            return finished

        return None

    def _release_resources(self, instr):
        name = instr.opcode.name
        if name.startswith("V_"):
            self.scoreboard.vector_busy = False
        elif name.startswith("T_"):
            self.scoreboard.tensor_busy = False
