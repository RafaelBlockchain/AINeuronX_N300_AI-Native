#!/bin/bash
# ====================================================
# run_noc.sh - Simulación completa de NoC Tile_Router
# ====================================================

set -euo pipefail

# ==============================
# Paths (relativos a la raíz del proyecto)
# ==============================
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
RTL_DIR="$PROJECT_ROOT/src/core_noc"
TB_DIR="$PROJECT_ROOT/tb/core_noc"
OBJ_DIR="$PROJECT_ROOT/obj_noc"

# ==============================
# DUT / Testbench
# ==============================
DUT="Tile_Router"
TB="TB_NOC"

# ==============================
# Cleaning
# ==============================
echo "► [NoC] Cleaning previous build..."
rm -rf "$OBJ_DIR"
mkdir -p "$OBJ_DIR"

# ==============================
# Compiling RTL + TB with Verilator
# ==============================
echo "► [NoC] Compiling RTL + TB..."
verilator --cc "$RTL_DIR/${DUT}.sv" \
          --exe "$TB_DIR/${TB}.sv" \
          --Mdir "$OBJ_DIR" \
          --Wall --Wno-fatal \
          --trace \
          --noassert \
          --timing || {
    echo "❌ [NoC] Verilator compilation failed. Check errors above."
    exit 1
}

# ==============================
# Building executable
# ==============================
echo "► [NoC] Building executable..."
make -C "$OBJ_DIR" -f "V${TB}.mk" "V${TB}" || {
    echo "❌ [NoC] Make failed. Check build logs in $OBJ_DIR."
    exit 1
}

# ==============================
# Running simulation
# ==============================
echo "► [NoC] Running simulation..."
"$OBJ_DIR/V${TB}" || {
    echo "❌ [NoC] Simulation crashed."
    exit 1
}

echo "✅ [NoC] Simulation finished successfully."
