#!/bin/bash
set -e

echo "► Cleaning previous build..."
rm -rf obj_dir wave_array_16x16.vcd

echo "► Compiling RTL + TB..."
verilator -Wall --cc --trace --no-timing \
  src/core/AINeuronX_N200_CORE_MAC.sv \
  src/array/AINeuronX_ARRAY_16x16_NOC.sv \
  tb/AINeuronX_ARRAY_16x16_NOC_TB.sv \
  --exe tb/sim_main_array_16x16.cpp \
  --top-module AINeuronX_ARRAY_16x16_NOC_TB \
  -Isrc/core -Isrc/array -Itb

echo "► Building executable..."
make -C obj_dir -f VAINeuronX_ARRAY_16x16_NOC_TB.mk

echo "► Running simulation..."
./obj_dir/VAINeuronX_ARRAY_16x16_NOC_TB

echo "✔ Waveform: wave_array_16x16.vcd"
gtkwave wave_array_16x16.vcd &
