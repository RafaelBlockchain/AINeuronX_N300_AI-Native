#!/bin/bash
# =====================================================
# RUN_SIM_LOG.SH
# Flujo completo AINeuronX con log ciclo a ciclo
# =====================================================

LOGFILE="simulation_log.txt"

# 1️⃣ Agregar timescale 1ns/1ps a todos los RTL si no existe
echo "🔹 Revisando y agregando \`timescale a RTL..."
for f in rtl/*.sv; do
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
verilator -Wall --cc rtl/*.sv \
  --exe tb/tb_aineuronx_full_pipeline.sv \
  --top-module aineuronx_chip \
  --timing

make -C obj_dir -f Vaineuronx_chip.mk

# 4️⃣ Ejecutar la simulación con log
echo "🔹 Ejecutando simulación y generando log en $LOGFILE..."
./obj_dir/Vaineuronx_chip | tee "$LOGFILE"

echo "✅ Flujo completo con log terminado."
echo "📄 Revisa $LOGFILE para inspeccionar entradas, salidas y golden model por ciclo."
