import json
import sys

from metrics.compute_metrics import (
    compute_ipc,
    utilization,
    compute_latency,
)


# Targets N300 (arquitectura concurrente con DMA y Tensor activos)
TARGET_IPC = 0.85
TARGET_VECTOR_UTIL = 0.4
TARGET_TENSOR_UTIL = 0.5
TARGET_DMA_UTIL = 0.3


def main():
    with open("emu_trace.json") as f:
        trace = json.load(f)

    ipc = compute_ipc(trace)
    vu = utilization(trace, "V")
    tu = utilization(trace, "T")
    du = utilization(trace, "DMA")
    lat = compute_latency(trace)

    failed = False

    if ipc < TARGET_IPC:
        print(f"IPC FAIL: {ipc:.3f} (target >= {TARGET_IPC})")
        failed = True

    if vu < TARGET_VECTOR_UTIL:
        print(f"Vector util FAIL: {vu:.3f} (target >= {TARGET_VECTOR_UTIL})")
        failed = True

    if tu < TARGET_TENSOR_UTIL:
        print(f"Tensor util FAIL: {tu:.3f} (target >= {TARGET_TENSOR_UTIL})")
        failed = True

    if du < TARGET_DMA_UTIL:
        print(f"DMA util FAIL: {du:.3f} (target >= {TARGET_DMA_UTIL})")
        failed = True

    if failed:
        print("❌ N300 PERFORMANCE TARGETS FAILED")
        sys.exit(1)

    print("✅ N300 PERFORMANCE TARGETS PASSED")
    print(f"IPC={ipc:.3f}, VU={vu:.3f}, TU={tu:.3f}, DU={du:.3f}, LAT={lat}")


if __name__ == "__main__":
    main()
    
