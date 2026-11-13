def simple_program():
    """
    Programa Golden mínimo del N200 (baseline vectorial).
    """
    return [
        {"opcode": "VADD"},
        {"opcode": "VADD"},
        {"opcode": "VADD"},
        {"opcode": "VADD"},
    ]


def n300_workload():
    """
    Carga de trabajo concurrente para el N300:
    Combina transferencias DMA, operaciones Tensor (TMUL) y Vector (VADD).
    """
    return [
        {"opcode": "DMA_LOAD"},
        {"opcode": "TMUL"},
        {"opcode": "VADD"},
        {"opcode": "DMA_LOAD"},
        {"opcode": "TMUL"},
        {"opcode": "TMUL"},
        {"opcode": "VADD"},
        {"opcode": "DMA_STORE"},
        {"opcode": "TMUL"},
        {"opcode": "VADD"},
    ]
    
