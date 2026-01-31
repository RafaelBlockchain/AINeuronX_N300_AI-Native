#!/bin/bash
# =====================================================
# RUN_PIPELINE_FULL_METRICS.SH
# Flujo completo AINeuronX: log + pipeline metrics + stalls/backpressure
# =====================================================

LOGFILE="simulation_log.txt"
SUMMARYFILE="pipeline_full_summary.txt"

# 1️⃣ Agregar timescale a RTL si falta
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
echo "🔹 Compilando RTL + TB..."
verilator -Wall --cc rtl/*.v \
    --exe tb/tb_aineuronx_full.sv \
    --top-module aineuronx_chip \
    --timing

make -C obj_dir -f Vaineuronx_chip.mk

# 4️⃣ Ejecutar simulación y guardar log
echo "🔹 Ejecutando simulación..."
./obj_dir/Vaineuronx_chip | tee "$LOGFILE"

# 5️⃣ Analizar log
echo "🔹 Analizando log y calculando métricas pipeline..."

TOTAL_CYCLES=$(grep -c "|" "$LOGFILE")
MISMATCHES=$(grep -c "❌ MISMATCH" "$LOGFILE")

# Extraer ciclos con valid_in y ready_chip
INPUT_CYCLES=($(grep -n "valid_in=1" "$LOGFILE" | cut -d: -f1))
READY_CYCLES=($(grep -n "ready_chip=1" "$LOGFILE" | cut -d: -f1))
OUTPUT_CYCLES=($(grep -n "|" "$LOGFILE" | grep -v "valid_in=0" | cut -d: -f1))

LATENCIAS=()
STALLED=0
BACKPRESSURE=0

for i in "${!INPUT_CYCLES[@]}"; do
    IN_CYCLE=${INPUT_CYCLES[i]}
    # Buscar el output correspondiente
    OUT_CYCLE=${OUTPUT_CYCLES[i]}
    LAT=$((OUT_CYCLE - IN_CYCLE))
    LATENCIAS+=($LAT)

    # Detectar burbujeo: ready=0 mientras valid_in=1
    if [[ " ${READY_CYCLES[@]} " =~ " $IN_CYCLE " ]]; then
        : # listo
    else
        STALLED=$((STALLED+1))
    fi

    # Detectar backpressure: ready=1 pero valid_in=0
    if [[ " ${READY_CYCLES[@]} " =~ " $IN_CYCLE " ]] && ! [[ " ${INPUT_CYCLES[@]} " =~ " $IN_CYCLE " ]]; then
        BACKPRESSURE=$((BACKPRESSURE+1))
    fi
done

# Latencias
MIN_LAT=$(printf "%s\n" "${LATENCIAS[@]}" | sort -n | head -1)
MAX_LAT=$(printf "%s\n" "${LATENCIAS[@]}" | sort -n | tail -1)
AVG_LAT=$(printf "%s\n" "${LATENCIAS[@]}" | awk '{sum+=$1} END {printf "%.2f", sum/NR}')

# Throughput = #outputs / total ciclos
THROUGHPUT=$(echo "${#OUTPUT_CYCLES[@]} / $TOTAL_CYCLES" | bc -l)

# Generar resumen
echo "===============================" > "$SUMMARYFILE"
echo "Pipeline FULL metrics AINeuronX" >> "$SUMMARYFILE"
echo "===============================" >> "$SUMMARYFILE"
echo "Total ciclos simulados : $TOTAL_CYCLES" >> "$SUMMARYFILE"
echo "Total mismatches       : $MISMATCHES" >> "$SUMMARYFILE"
if [ "$MISMATCHES" -eq 0 ]; then
    echo "✅ Todos los ciclos correctos según golden model" >> "$SUMMARYFILE"
else
    echo "❌ Se encontraron mismatches. Revisa $LOGFILE" >> "$SUMMARYFILE"
fi
echo "Latencia mínima       : $MIN_LAT ciclos" >> "$SUMMARYFILE"
echo "Latencia máxima       : $MAX_LAT ciclos" >> "$SUMMARYFILE"
echo "Latencia promedio     : $AVG_LAT ciclos" >> "$SUMMARYFILE"
echo "Throughput sostenido  : $THROUGHPUT datos/ciclo" >> "$SUMMARYFILE"
echo "Ciclos con stalls     : $STALLED" >> "$SUMMARYFILE"
echo "Ciclos con backpressure : $BACKPRESSURE" >> "$SUMMARYFILE"

# Mostrar resumen final
cat "$SUMMARYFILE"
echo "✅ Flujo pipeline completo terminado."
echo "📄 Log: $LOGFILE"
echo "📄 Resumen metrics: $SUMMARYFILE"
