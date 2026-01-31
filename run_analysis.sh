#!/bin/bash
# Ejecuta el análisis Python y genera PDF/CSV
echo "=== Analizando resultados y generando reportes ==="
python3 python_api/analyze_full.py
if [ $? -eq 0 ]; then
    echo "Reportes generados correctamente:"
    echo "- PDF: AINeuronX_metrics.pdf"
    echo "- CSV clusters: cluster_metrics.csv"
    echo "- CSV subarrays: subarray_usage.csv"
    echo "- TXT reporte: AINeuronX_report.txt"
else
    echo "Error en el análisis Python."
    exit 1
fi
