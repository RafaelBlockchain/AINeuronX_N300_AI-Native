from .attention import attention
from .matmul import matmul

def transformer_block(q, k, v, w, out):
    instrs = []
    instrs.append(attention(q, k, v, "attn_out"))
    instrs.append(matmul("attn_out", w, out))
    return instrs
