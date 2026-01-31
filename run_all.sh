#!/bin/bash
echo "=== Pipeline completo: Build → Simulación → Análisis ==="
./build.sh
./run_runtime.sh
./run_analysis.sh
echo "=== Pipeline completado ==="
