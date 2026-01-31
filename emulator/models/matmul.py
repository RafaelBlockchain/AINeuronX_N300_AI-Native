from emulator.core.isa import Instruction, OpCode

def matmul(a, b, out):
    return Instruction(
        opcode=OpCode.MATMUL,
        src=[a, b],
        dst=out
    )
