#!/bin/bash
set -e

TOP=tb_soc_basic
OUT=sim.out

iverilog -g2012 \
  -Isrc/common \
  -Isrc/noc \
  -Isrc/tile \
  -Isrc/top \
  -o $OUT \
  src/common/*.sv \
  src/noc/*.sv \
  src/tile/*.sv \
  src/top/*.sv \
  tb/soc/$TOP.sv \
  tb/noc/*.sv

vvp $OUT
