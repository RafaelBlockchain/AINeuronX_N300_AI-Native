#!/bin/bash
# =====================================================
# RUN_PIPELINE_METRICS.SH
# Flujo completo AINeuronX + log + métricas pipeline-accurate
# =====================================================

LOGFILE="simulation_log.txt"
SUMMARYFILE="pipeline_summary.txt"

# 1️⃣ Agregar timescale 1ns/1ps a RTL si falta
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

# 3️⃣ Compilar con Verilator
echo "🔹 Compilando con Verilator..."
verilator -Wall --cc rtl/*.v \
    --exe tb/tb_aineuronx_full.sv \
    --top-module aineuronx_chip \
    --timing

make -C obj_dir -f Vaineuronx_chip.mk

# 4️⃣ Ejecutar simulación y guardar log
echo "🔹 Ejecutando simulación y guardando log..."
./obj_dir/Vaineuronx_chip | tee "$LOGFILE"

# 5️⃣ Calcular métricas pipeline
echo "🔹 Calculando métricas pipeline-accurate..."

TOTAL_CYCLES=$(grep -c "|" "$LOGFILE")
MISMATCHES=$(grep -c "❌ MISMATCH" "$LOGFILE")

# Latencia: suposición simple para este TB: output aparece X ciclos después de input
# Tomamos ciclos donde valid_in=1 y ready_chip=1
INPUT_CYCLES=($(grep -n "valid_in=1" "$LOGFILE" | cut -d: -f1))
OUTPUT_CYCLES=($(grep -n "|" "$LOGFILE" | grep -v "valid_in=0" | cut -d: -f1))

LATENCIAS=()
for i in "${!INPUT_CYCLES[@]}"; do
    IN_CYCLE=${INPUT_CYCLES[i]}
    OUT_CYCLE=${OUTPUT_CYCLES[i]}
    LAT=$((OUT_CYCLE - IN_CYCLE))
    LATENCIAS+=($LAT)
done

# Throughput = #outputs / total ciclos
THROUGHPUT=$(echo "${#OUTPUT_CYCLES[@]} / $TOTAL_CYCLES" | bc -l)

# Resumen
echo "===============================" > "$SUMMARYFILE"
echo "Pipeline metrics AINeuronX" >> "$SUMMARYFILE"
echo "===============================" >> "$SUMMARYFILE"
echo "Total ciclos simulados : $TOTAL_CYCLES" >> "$SUMMARYFILE"
echo "Total mismatches       : $MISMATCHES" >> "$SUMMARYFILE"
if [ "$MISMATCHES" -eq 0 ]; then
    echo "✅ Todos los ciclos correctos según golden model" >> "$SUMMARYFILE"
else
    echo "❌ Se encontraron mismatches. Revisa $LOGFILE" >> "$SUMMARYFILE"
fi
# Latencias
if [ "${#LATENCIAS[@]}" -gt 0 ]; then
    MIN_LAT=$(printf "%s\n" "${LATENCIAS[@]}" | sort -n | head -1)
    MAX_LAT=$(printf "%s\n" "${LATENCIAS[@]}" | sort -n | tail -1)
    AVG_LAT=$(printf "%s\n" "${LATENCIAS[@]}" | awk '{sum+=$1} END {printf "%.2f", sum/NR}')
    echo "Latencia mínima : $MIN_LAT ciclos" >> "$SUMMARYFILE"
    echo "Latencia máxima : $MAX_LAT ciclos" >> "$SUMMARYFILE"
    echo "Latencia promedio : $AVG_LAT ciclos" >> "$SUMMARYFILE"
fi
# Throughput
echo "Throughput sostenido : $THROUGHPUT datos/ciclo" >> "$SUMMARYFILE"

# Mostrar resumen final
cat "$SUMMARYFILE"
echo "✅ Flujo completo terminado. Log en $LOGFILE, resumen en $SUMMARYFILE."
