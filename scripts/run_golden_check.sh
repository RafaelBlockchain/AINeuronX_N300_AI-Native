#!/bin/bash
set -e

./scripts/run_emulator.sh
./scripts/run_rtl.sh

echo "[GOLDEN] Comparing traces..."
python3 emulator/compare/rtl_compare.py emu_trace.json rtl_trace.json
echo "[GOLDEN] PASS"
