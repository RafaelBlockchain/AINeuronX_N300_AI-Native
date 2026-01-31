from isa_n200 import ISA

def emit(op):
    if op.opcode == ISA.TMATMUL:
        return f"TMATMUL {op.args}"
    elif op.opcode == ISA.BARRIER:
        return "BARRIER"
    elif op.opcode == ISA.SYNC_DMA:
        return f"SYNC_DMA {op.args[0]}"
    else:
        raise CompileError(f"Unsupported op {op.opcode}")
