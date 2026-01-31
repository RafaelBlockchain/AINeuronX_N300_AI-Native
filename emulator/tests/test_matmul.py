from emulator.core.kernel import Kernel
from models.matmul import matmul

def test_matmul():
    k = Kernel("mm")
    k.emit(matmul("A", "B", "C"))
    assert len(list(k)) == 1
