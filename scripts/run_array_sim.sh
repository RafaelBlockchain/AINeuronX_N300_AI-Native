#!/bin/bash
set -e

echo "► [ARRAY 2x2] Cleaning previous build..."
rm -rf obj_dir wave_array_2x2.vcd

echo "► [ARRAY 2x2] Compiling RTL + TB (sin timing)..."
verilator -Wall --cc --trace --no-timing \
  src/core/AINeuronX_N200_CORE.sv \
  src/array/AINeuronX_ARRAY_2x2.sv \
  tb/AINeuronX_ARRAY_2x2_TB.sv \
  --exe tb/sim_main_array.cpp \
  --top-module AINeuronX_ARRAY_2x2_TB \
  -Isrc/core \
  -Isrc/array \
  -Itb

echo "► [ARRAY 2x2] Building executable..."
make -C obj_dir -f VAINeuronX_ARRAY_2x2_TB.mk

echo "► [ARRAY 2x2] Running simulation..."
./obj_dir/VAINeuronX_ARRAY_2x2_TB

echo "✔ ARRAY 2x2 simulation finished"
echo "✔ Waveform generated: wave_array_2x2.vcd"
echo "► Launching GTKWave..."
gtkwave wave_array_2x2.vcd &
