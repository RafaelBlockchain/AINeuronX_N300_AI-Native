#!/bin/bash
echo "▸ Cleaning previous build..."
rm -rf obj_dir

echo "► Verilating RTL + TB..."
verilator -Wall --timing --cc --exe --build \
    src/AINeuronX_N200_CORE.SV \
    src/AINeuronX_N200_TB.SV \
    --trace

SIM=./obj_dir/VAINeuronX_N200_TB

if [ -f "$SIM" ]; then
    echo "► Running simulation..."
    $SIM
    echo "✔ Simulation finished"
    echo "✔ Waveform: obj_dir/waves.fst"
else
    echo "❌ Simulation binary not found"
fi
