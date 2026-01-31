from isa_n200 import ISA

class CompileError(Exception):
    pass

def validate_ir(ir_ops):
    for i, op in enumerate(ir_ops):
        if not isinstance(op.opcode, ISA):
            raise CompileError(f"Invalid opcode at {i}")

        if op.opcode in (ISA.DMA_RECV, ISA.DMA_SEND):
            if i+1 >= len(ir_ops) or ir_ops[i+1].opcode != ISA.SYNC_DMA:
                raise CompileError("DMA without SYNC_DMA")
