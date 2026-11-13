import json
import sys

from metrics.compute_metrics import (
    compute_ipc,
    utilization,
    compute_latency,
)


# Targets N200 (baseline realista)
TARGET_IPC = 1.0
TARGET_VECTOR_UTIL = 1.0
TARGET_TENSOR_UTIL = 0.5  # permitido en N300
TARGET_DMA_UTIL = 0.3     # permitido en N300


def main():
    with open("emu_trace.json") as f:
        trace = json.load(f)

    ipc = compute_ipc(trace)
    vu = utilization(trace, "V")      # VADD → OK
    tu = utilization(trace, "T")
    du = utilization(trace, "DMA")
    lat = compute_latency(trace)

    failed = False

    if ipc < TARGET_IPC:
        print(f"IPC FAIL: {ipc}")
        failed = True

    if vu < TARGET_VECTOR_UTIL:
        print(f"Vector util FAIL: {vu}")
        failed = True

    if tu < TARGET_TENSOR_UTIL:
        print(f"Tensor util FAIL: {tu}")
        failed = True

    if du < TARGET_DMA_UTIL:
        print(f"DMA util FAIL: {du}")
        failed = True

    if failed:
        print("❌ N200 PERFORMANCE TARGETS FAILED")
        sys.exit(1)

    print("✅ N200 PERFORMANCE TARGETS PASSED")
    print(f"IPC={ipc:.3f}, VU={vu:.3f}, TU={tu:.3f}, DU={du:.3f}, LAT={lat}")


if __name__ == "__main__":
    main()
