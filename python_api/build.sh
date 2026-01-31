#!/bin/bash
# build.sh — compila todo el RTL para simulación

echo "Compilando todos los módulos RTL de AINeuronX..."
iverilog -g2012 \
    tensor_core_array.v tensor_subarray.v \
    l1_cache_adaptive.v l2_cache.v \
    compute_cluster.v aineuronx_chip.v \
    memory_controller.v dma_engine.v crossbar_network.v \
    nvlink_pcie_link.v power_model.v error_injection.v \
    clock_reset_gen.v \
    tb_aineuronx_full.v \
    -o sim_aineuronx.out

if [ $? -eq 0 ]; then
    echo "Compilación exitosa."
else
    echo "Error en compilación."
    exit 1
fi

