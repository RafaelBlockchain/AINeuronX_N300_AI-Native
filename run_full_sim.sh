#!/bin/bash
# =====================================================
# RUN_FULL_SIM.SH
# Flujo completo AINeuronX: clean RTL + Verilator + TB + log
# =====================================================

LOGFILE="simulation_log.txt"
USE_LOG=1  # 1 = guardar log ciclo a ciclo, 0 = solo stdout

# 1️⃣ Agregar timescale 1ns/1ps a todos los RTL si no existe
echo "🔹 Revisando y agregando \`timescale a RTL..."
for f in rtl/*.v; do
    if ! grep -q "`timescale" "$f"; then
        sed -i '1i`timescale 1ns/1ps' "$f"
        echo "  ✔ timescale agregado a $f"
    fi
done

# 2️⃣ Limpiar compilaciones previas
echo "🔹 Limpiando compilaciones previas..."
rm -rf obj_dir
rm -f "$LOGFILE"

# 3️⃣ Compilar RTL + testbench con Verilator
echo "🔹 Compilando con Verilator..."
verilator -Wall --cc rtl/*.v \
    --exe tb/tb_aineuronx_full.sv \
    --top-module aineuronx_chip \
    --timing

make -C obj_dir -f Vaineuronx_chip.mk

# 4️⃣ Ejecutar la simulación
echo "🔹 Ejecutando simulación..."
if [ $USE_LOG -eq 1 ]; then
    ./obj_dir/Vaineuronx_chip | tee "$LOGFILE"
    echo "📄 Log guardado en $LOGFILE"
else
    ./obj_dir/Vaineuronx_chip
fi

echo "✅ Flujo completo terminado."
