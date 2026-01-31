#!/bin/bash
# ====================================================
# run_noc.sh - Simulación completa de NoC Tile_Router
# ====================================================

set -e

RTL_DIR=src/core_noc
TB_DIR=tb/core_noc
OBJ_DIR=obj_noc

DUT=Tile_Router
TB=TB_NOC

echo "► [NoC] Cleaning previous build..."
rm -rf $OBJ_DIR
mkdir -p $OBJ_DIR

echo "► [NoC] Compiling RTL + TB..."
verilator --cc \
    $RTL_DIR/Tile_Power.sv \
    $RTL_DIR/Tile_Arbiter.sv \
    $RTL_DIR/Tile_FIFO.sv \
    $RTL_DIR/Tile_Metrics.sv \
    $RTL_DIR/${DUT}.sv \
    --exe $TB_DIR/${TB}.sv \
    --Mdir $OBJ_DIR \
    --Wall --Wno-fatal \
    --trace \
    --noassert \
    --timing

echo "► [NoC] Building executable..."
make -C $OBJ_DIR -f V${TB}.mk V${TB}

echo "► [NoC] Running simulation..."
$OBJ_DIR/V${TB}

echo "► [NoC] Simulation finished. VCD: $OBJ_DIR/V${TB}.v"
