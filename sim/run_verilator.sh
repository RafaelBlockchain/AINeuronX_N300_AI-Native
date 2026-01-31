#!/bin/bash
set -e

verilator --cc --exe --build \
  -Isrc/common \
  -Isrc/noc \
  -Isrc/tile \
  -Isrc/top \
  tb/soc/tb_soc_basic.sv \
  src/common/*.sv \
  src/noc/*.sv \
  src/tile/*.sv \
  src/top/*.sv \
  --top-module tb_soc_basic

./obj_dir/Vtb_soc_basic
