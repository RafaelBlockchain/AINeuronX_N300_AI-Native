#pragma once
#include <cstdint>

namespace hw {

void issue_barrier();
void send(uint32_t dst_tile, const void* data, uint32_t size);
void recv(uint32_t src_tile, void* data, uint32_t size);

uint32_t dma_send(const void* local, uint64_t dram_addr, uint32_t size);
uint32_t dma_recv(uint64_t dram_addr, void* local, uint32_t size);
void sync_dma(uint32_t dma_id);

} // namespace hw
