void Buffer::load_from_dram(uint64_t addr, uint32_t size) {
    dma_id = hw::dma_recv(addr, data, size);
}

void Buffer::wait_ready() {
    if (dma_id != INVALID_DMA)
        hw::sync_dma(dma_id);
}

