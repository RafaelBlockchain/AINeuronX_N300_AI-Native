#!/bin/bash
set -e

echo "[EMU] Running Golden Emulator..."
python3 emulator/run.py
python3 - <<EOF
from emulator.logging.logger import EventLogger
# asumimos que run.py deja logger global
# export explícito
EOF
mv emu_trace.json emu_trace.json
echo "[EMU] Done"
