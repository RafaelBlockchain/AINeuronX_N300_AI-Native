from enum import Enum

LATENCY_TABLE = {
    "SCALAR": 1,
    "VECTOR": 4,
    "DMA": 8,
    "T_MATMUL": 32,
    "T_REDUCE": 16,
}


class OpType(Enum):
    SCALAR = 0
    VECTOR = 1
    TENSOR = 2
    DMA = 3

class Opcode(Enum):
    SC_ADD = 0
    SC_SUB = 1
    SC_BRANCH = 2
    SC_BARRIER = 3

    V_ADD = 10
    V_MUL = 11
    V_LOAD = 12
    V_STORE = 13

    T_MATMUL = 20
    T_REDUCE = 21

    DMA_LOAD = 30
    DMA_STORE = 31
    DMA_WAIT = 32

