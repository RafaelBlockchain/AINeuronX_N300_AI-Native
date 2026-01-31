#!/bin/bash
set -e

echo "▶ [ARRAY] Cleaning previous build..."
rm -rf obj_dir

echo "▶ [ARRAY] Compiling RTL + TB..."

verilator -Wall --timing --trace \
  --cc \
  src/core/AINeuronX_N200_CORE.sv \
  src/tile/AINeuronX_N200_TILE.sv \
  src/tile/AINeuronX_TILE_DMA.sv \
  src/tile/AINeuronX_L1_SRAM.sv \
  src/noc/AINeuronX_NOC_ROUTER.sv \
  src/array/AINeuronX_ARRAY.sv \
  tb/AINeuronX_ARRAY_TB.sv \
  --exe tb/sim_main.cpp \
  --top-module AINeuronX_ARRAY_TB \
  --build

SIM=./obj_dir/VAINeuronX_ARRAY_TB

if [ -f "$SIM" ]; then
    echo "▶ [ARRAY] Running simulation..."
    $SIM
    echo "✔ [ARRAY] Simulation finished"
    echo "✔ Waveform: wave.vcd"
else
    echo "❌ [ARRAY] Simulation binary not found"
    exit 1
fi
