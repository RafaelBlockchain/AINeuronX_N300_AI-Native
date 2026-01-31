#!/bin/bash
set -e

echo "► [N200 CORE] Cleaning previous build..."
rm -rf obj_dir

echo "► [N200 CORE] Compiling RTL + TB..."

verilator -Wall --timing --trace \
  --cc \
  src/core/AINeuronX_N200_CORE.sv \
  tb/AINeuronX_N200_TB.sv \
  --exe tb/sim_main_core.cpp \
  --top-module AINeuronX_N200_TB \
  --build

SIM=./obj_dir/VAINeuronX_N200_TB

if [ -f "$SIM" ]; then
    echo "► [N200 CORE] Running simulation..."
    $SIM
    echo "✔ [N200 CORE] Simulation finished"
    echo "✔ Waveform generated: wave.vcd"
else
    echo "❌ [N200 CORE] Simulation binary not found"
    exit 1
fi
