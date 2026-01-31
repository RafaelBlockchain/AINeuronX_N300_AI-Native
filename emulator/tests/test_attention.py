from emulator.core.kernel import Kernel
from models.attention import attention

def test_attention():
    k = Kernel("attn")
    k.emit(attention("Q","K","V","O"))
    assert len(list(k)) == 1
