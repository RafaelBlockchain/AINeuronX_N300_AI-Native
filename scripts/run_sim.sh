#!/bin/bash
set -e

echo "▸ Cleaning previous build..."
rm -rf obj_dir

echo "► Verilating RTL + TB (N200_CORE)..."
verilator -Wall --timing --cc --exe --build \
  src/core/AINeuronX_N200_CORE.sv \
  tb/AINeuronX_N200_TB.sv \
  --trace

SIM=./obj_dir/VAINeuronX_N200_TB

if [ -f "$SIM" ]; then
    echo "► Running simulation..."
    $SIM
    echo "✔ Simulation finished"
    echo "✔ Waveform generated: obj_dir/waves.fst"
    echo "► Open GTKWave: gtkwave obj_dir/waves.fst"
else
    echo "❌ Simulation binary not found"
fi
