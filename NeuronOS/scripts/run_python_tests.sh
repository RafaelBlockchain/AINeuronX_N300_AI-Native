#!/bin/bash
# Ejecuta todos los scripts Python de prueba y genera heatmaps

# Crear carpeta de heatmaps si no existe
mkdir -p ../python_api/heatmaps

echo "Ejecutando scripts Python de prueba..."
python3 ../python_api/test_kernel.py
python3 ../python_api/heatmap_visual.py

echo "Pruebas Python completadas. Revisar logs/ y heatmaps generados en ../python_api/heatmaps/"
