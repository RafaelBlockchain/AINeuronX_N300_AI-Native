#!/bin/bash
echo "► [FP8 MAC] Cleaning previous build..."
rm -rf obj_dir fp8_mac.vcd

echo "► [FP8 MAC] Compiling RTL + TB..."
verilator -Wall --cc \
    -Isrc/core_fp8 \
    tb/core_fp8/AINeuronX_FP8_MAC_TB.sv \
    --exe tb/core_fp8/sim_fp8_mac.cpp \
    --trace \
    --no-timing   # importante para delays y @(posedge clk)

if [ $? -ne 0 ]; then
    echo "► [FP8 MAC] Compilation failed"
    exit 1
fi

echo "► [FP8 MAC] Building..."
make -C obj_dir -f VAINeuronX_FP8_MAC_TB.mk

if [ $? -ne 0 ]; then
    echo "► [FP8 MAC] Build failed"
    exit 1
fi

echo "► [FP8 MAC] Running simulation..."
obj_dir/VAINeuronX_FP8_MAC_TB
