#!/bin/bash
# ====================================================
# run_noc_full.sh - Simulación escalable NoC 32x32 / 64x64
# ====================================================

set -e

RTL_DIR=src/core_noc
TB_DIR=tb/core_noc
OBJ_DIR=obj_noc_full

DUT=Tile_Router
TB=TB_NOC_Full

echo "► [NoC Full] Cleaning previous build..."
rm -rf $OBJ_DIR
mkdir -p $OBJ_DIR

echo "► [NoC Full] Compiling RTL + TB..."
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

echo "► [NoC Full] Building executable..."
make -C $OBJ_DIR -f V${TB}.mk V${TB}

echo "► [NoC Full] Running simulation..."
$OBJ_DIR/V${TB}

echo "► [NoC Full] Simulation finished. VCD: $OBJ_DIR/V${TB}.v"
