#!/bin/bash
# =====================================================
# RUN_FULL_SIM_SUMMARY.SH
# Flujo completo AINeuronX + log + resumen de mismatches
# =====================================================

LOGFILE="simulation_log.txt"
SUMMARYFILE="simulation_summary.txt"

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
rm -f "$LOGFILE" "$SUMMARYFILE"

# 3️⃣ Compilar RTL + testbench con Verilator
echo "🔹 Compilando con Verilator..."
verilator -Wall --cc rtl/*.v \
    --exe tb/tb_aineuronx_full.sv \
    --top-module aineuronx_chip \
    --timing

make -C obj_dir -f Vaineuronx_chip.mk

# 4️⃣ Ejecutar simulación con log
echo "🔹 Ejecutando simulación..."
./obj_dir/Vaineuronx_chip | tee "$LOGFILE"

# 5️⃣ Analizar log y generar resumen
TOTAL_CYCLES=$(grep -c "|" "$LOGFILE")
MISMATCHES=$(grep -c "❌ MISMATCH" "$LOGFILE")

echo "===============================" >> "$SUMMARYFILE"
echo "Resumen de simulación AINeuronX" >> "$SUMMARYFILE"
echo "===============================" >> "$SUMMARYFILE"
echo "Total ciclos simulados : $TOTAL_CYCLES" >> "$SUMMARYFILE"
echo "Total mismatches       : $MISMATCHES" >> "$SUMMARYFILE"

if [ "$MISMATCHES" -eq 0 ]; then
    echo "✅ Todos los ciclos correctos según golden model" >> "$SUMMARYFILE"
else
    echo "❌ Se encontraron mismatches. Revisa $LOGFILE" >> "$SUMMARYFILE"
fi

# Mostrar resumen final
cat "$SUMMARYFILE"
echo "✅ Flujo completo terminado. Log en $LOGFILE, resumen en $SUMMARYFILE."
