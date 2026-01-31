#!/bin/bash
# ==================================================
# Script de compilación y simulación Verilator
# para AINeuronX core vectorizado + TB
# ==================================================

# Limpiar compilaciones anteriores
echo "▸ Cleaning previous build..."
rm -rf obj_dir

# Verilating RTL + TB
echo "► Verilating RTL + TB..."
verilator -Wall --cc \
    --exe \
    --build \
    -I./src \
    src/aineuronx_core_vector.sv \
    src/aineuronx_tb_vector.sv \
    --trace

# Verilated binary
SIM_BINARY=./obj_dir/Vaineuronx_tb_vector

# Ejecutar simulación
if [ -f "$SIM_BINARY" ]; then
    echo "► Running simulation..."
    $SIM_BINARY
    echo "✔ Simulation finished"
    echo "✔ Waveform generated: obj_dir/waves.fst"
else
    echo "❌ Simulation binary not found"
fi
