#!/bin/bash
set -e

echo "► Running full simulation: CORE + ARRAY 2x2 (no timing)"

# -------------------------
# Simulación del CORE individual
# -------------------------
run_core() {
    echo "▸ [CORE] Cleaning previous build..."
    rm -rf obj_dir

    echo "► [CORE] Verilating RTL + TB (no timing)..."
    verilator -Wall --cc --trace --no-timing \
      ../src/core/AINeuronX_N200_CORE.sv \
      ../tb/AINeuronX_N200_TB.sv \
      --exe ../tb/sim_main_core.cpp \
      --top-module AINeuronX_N200_TB \
      -Isrc/core \
      -Itb

    echo "► [CORE] Building executable..."
    make -C obj_dir -f VAINeuronX_N200_TB.mk

    echo "► [CORE] Running simulation..."
    ./obj_dir/VAINeuronX_N200_TB

    echo "✔ [CORE] Simulation finished"
    echo "✔ Waveform: obj_dir/waves.fst"
}

# -------------------------
# Simulación del ARRAY 2x2
# -------------------------
run_array() {
    echo "► [ARRAY 2x2] Cleaning previous build..."
    rm -rf obj_dir wave_array_2x2.vcd

    echo "► [ARRAY 2x2] Verilating RTL + TB (no timing)..."
    verilator -Wall --cc --trace --no-timing \
      ../src/core/AINeuronX_N200_CORE.sv \
      ../src/array/AINeuronX_ARRAY_2x2.sv \
      ../tb/AINeuronX_ARRAY_2x2_TB.sv \
      --exe ../tb/sim_main_array.cpp \
      --top-module AINeuronX_ARRAY_2x2_TB \
      -Isrc/core \
      -Isrc/array \
      -Itb

    echo "► [ARRAY 2x2] Building executable..."
    make -C obj_dir -f VAINeuronX_ARRAY_2x2_TB.mk

    echo "► [ARRAY 2x2] Running simulation..."
    ./obj_dir/VAINeuronX_ARRAY_2x2_TB

    echo "✔ [ARRAY 2x2] Simulation finished"
    echo "✔ Waveform: wave_array_2x2.vcd"
}

# -------------------------
# Ejecutar ambas simulaciones
# -------------------------
run_core
run_array

# -------------------------
# Abrir GTKWave automáticamente
# -------------------------
echo "► Launching GTKWave..."
gtkwave obj_dir/waves.fst &
gtkwave wave_array_2x2.vcd &

echo "✔ GTKWave launched with CORE and ARRAY waveforms"
