from metrics.parse_trace import load_trace
from metrics.compute_metrics import compute_latency, compute_ipc, utilization
from metrics.report import print_report

trace = load_trace("emu_trace.json")

metrics = {
    "Latency (cycles)": compute_latency(trace),
    "IPC": compute_ipc(trace),
    "Vector Util": utilization(trace, "V"),
    "Tensor Util": utilization(trace, "T"),
    "DMA Util": utilization(trace, "DMA"),
}

print_report(metrics)
