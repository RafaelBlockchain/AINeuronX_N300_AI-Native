def compute_ipc(trace):
    """
    Instructions Per Cycle.
    En N200: cada evento COMMIT cuenta como 1 instrucción.
    """
    if not trace:
        return 0.0

    cycles = max(e["cycle"] for e in trace) + 1

    instructions = sum(
        1 for e in trace
        if e.get("event") == "COMMIT"
    )

    return instructions / cycles if cycles > 0 else 0.0


def utilization(trace, prefix):
    """
    Utilización por tipo de unidad.
    prefix: "V" para vector, "T" para tensor, "DMA" para DMA.
    """
    if not trace:
        return 0.0

    active = sum(
        1 for e in trace
        if e.get("opcode") and e["opcode"].startswith(prefix)
    )

    return active / len(trace)


def compute_latency(trace):
    """
    Latencia simple: número de eventos COMMIT.
    """
    if not trace:
        return 0

    commits = [e for e in trace if e.get("event") == "COMMIT"]
    return len(commits)
