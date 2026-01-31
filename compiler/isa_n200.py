from enum import Enum, auto

class ISA(Enum):
    # Tensor
    TLOAD = auto()
    TSTORE = auto()
    TMATMUL = auto()
    TCONV = auto()
    TACT = auto()

    # Vector
    VLOAD = auto()
    VSTORE = auto()
    VADD = auto()
    VMUL = auto()
    VREDUCE = auto()

    # Control
    BARRIER = auto()
    SEND = auto()
    RECV = auto()
    SYNC = auto()
    SYNC_DMA = auto()

    # Memory
    LD_LOCAL = auto()
    ST_LOCAL = auto()
    DMA_SEND = auto()
    DMA_RECV = auto()
