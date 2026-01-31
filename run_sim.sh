#!/bin/bash
set -e

echo "▸ Cleaning previous build..."
rm -rf obj_dir waves.fst

echo "► Verilating RTL + TB..."

verilator -Wall --cc \
  rtl/*.sv \
  tb/aineuronx.sv \
  --top-module aineuronx \
  --exe main.cpp \
  --timing \
  --trace-fst

echo "► Building simulation..."
make -C obj_dir -f Vaineuronx.mk

echo "► Running simulation..."
./obj_dir/Vaineuronx

echo "✔ Simulation finished"
echo "✔ Waveform generated: waves.fst"
