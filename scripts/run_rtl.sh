#!/bin/bash
set -e

echo "[RTL] Building RTL..."
iverilog -g2012 \
  rtl/decoder/*.sv \
  rtl/core/*.sv \
  rtl/compute/*.sv \
  rtl/memory/*.sv \
  rtl/noc/*.sv \
  rtl/debug/*.sv \
  rtl/top/tile_top.sv \
  tb/tb_tile_vs_emulator.sv \
  -o tile_sim

echo "[RTL] Running simulation..."
vvp tile_sim > rtl_trace.json
echo "[RTL] Done"
