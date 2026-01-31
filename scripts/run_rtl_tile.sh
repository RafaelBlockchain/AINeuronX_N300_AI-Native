#!/bin/bash
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

vvp tile_sim > rtl_trace.json
