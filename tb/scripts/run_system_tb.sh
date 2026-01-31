#!/bin/bash
set -e

echo "======================================"
echo " AINeuronX N200 – System Testbench"
echo " Scenario: sc_basic_boot"
echo "======================================"

ROOT_DIR=$(pwd)

RTL_DIR="$ROOT_DIR/rtl"
TB_DIR="$ROOT_DIR/tb"

OUT_BIN="system_tb.out"

echo "[1/3] Compilando RTL + Testbench..."

iverilog -g2012 \
  -I $RTL_DIR/tiles \
  -I $RTL_DIR/noc \
  -I $RTL_DIR/top \
  -I $TB_DIR/system \
  -I $TB_DIR/scenarios \
  $RTL_DIR/tiles/tile_if.sv \
  $RTL_DIR/tiles/tile_tensor.sv \
  $RTL_DIR/tiles/tile_vector.sv \
  $RTL_DIR/tiles/tile_control.sv \
  $RTL_DIR/noc/noc_router.sv \
  $RTL_DIR/noc/noc_channel.sv \
  $RTL_DIR/noc/noc_regs.sv \
  $RTL_DIR/noc/noc_mesh.sv \
  $RTL_DIR/top/aineuronx_top.sv \
  $TB_DIR/system/tb_system_top.sv \
  -o $OUT_BIN

echo "[2/3] Compilación OK"

echo "[3/3] Ejecutando simulación..."
vvp $OUT_BIN

echo "======================================"
echo " System TB finalizado"
echo "======================================"
