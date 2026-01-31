from emulator.core.isa import Instruction, OpCode

def attention(q, k, v, out):
    return Instruction(
        opcode=OpCode.ATTENTION,
        src=[q, k, v],
        dst=out
    )
