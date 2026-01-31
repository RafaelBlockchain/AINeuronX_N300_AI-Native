from enum import Enum

class GlobalState(Enum):
    RUNNING = 0
    GLOBAL_STALL = 1
    DONE = 2
    ERROR = 3

class TileState(Enum):
    IDLE = 0
    EXEC_SCALAR = 1
    EXEC_VECTOR = 2
    EXEC_TENSOR = 3
    WAIT_DMA = 4
    STALLED = 5
