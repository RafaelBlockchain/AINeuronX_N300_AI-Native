#include "scheduler.h"
#include "runtime_hw_if.h"

void Scheduler::run_task(const Task& task) {
    for (const auto& op : task.ops) {
        switch (op.type) {

        case OpType::KERNEL:
            launch_kernel(op.kernel);
            break;

        case OpType::BARRIER:
            hw::issue_barrier();
            break;

        case OpType::DMA_SEND: {
            uint32_t id = hw::dma_send(
                op.local_ptr, op.dram_addr, op.size);
            pending_dmas.push_back(id);
            break;
        }

        case OpType::DMA_RECV: {
            uint32_t id = hw::dma_recv(
                op.dram_addr, op.local_ptr, op.size);
            pending_dmas.push_back(id);
            break;
        }

        case OpType::SYNC_DMA:
            hw::sync_dma(op.dma_id);
            break;
        }
    }
}

