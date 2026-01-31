#!/bin/bash
# Compila todos los módulos RTL en una simulación unificada
echo "=== Compilando RTL de AINeuronX ==="

iverilog -g2012 -o tb_aineuronx_full.out \
    rtl/tensor_core_array.v \
    rtl/tensor_subarray.v \
    rtl/l1_cache_adaptive.v \
    rtl/l2_cache.v \
    rtl/compute_cluster.v \
    rtl/memory_controller.v \
    rtl/dma_engine.v \
    rtl/crossbar_network.v \
    rtl/nvlink_pcie_link.v \
    rtl/power_model.v \
    rtl/error_injection.v \
    rtl/clock_reset_gen.v \
    rtl/aineuronx_chip.v \
    testbench/tb_aineuronx_full.v

if [ $? -eq 0 ]; then
    echo "Compilación completada correctamente."
else
    echo "Error en la compilación."
    exit 1
fi
