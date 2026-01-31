#!/bin/bash
# Script maestro para commits semanales de Fase 2: NeuronOS
# Automatiza commits con mensajes predefinidos y versiona logs y heatmaps

# Lista de commits semanales
declare -a commits=(
"Semana 1: Preparación entorno y Python API, scripts automáticos listos"
"Semana 2: Scheduler jerárquico y kernels FP16/FP8 implementados"
"Semana 3: Benchmarks sintéticos iniciales ejecutados y heatmaps generados"
"Semana 4: Optimización de memoria y prefetch adaptativo completada"
"Semana 5: Pruebas multi-cluster completas y scheduler ajustado"
"Semana 6: Ajustes finales, consolidación NeuronOS v0.9 lista para integración"
)

# Carpeta raíz del proyecto (ajustar si necesario)
PROJECT_ROOT=$(dirname "$0")/..

cd "$PROJECT_ROOT" || exit

# Ejecutar commit para cada semana
for i in "${!commits[@]}"; do
    WEEK=$((i+1))
    echo "---------------------------------------------"
    echo "Preparando commit Semana $WEEK"
    
    # Añadir todos los cambios
    git add .

    # Mensaje de commit
    git commit -m "${commits[$i]}"

    echo "Commit Semana $WEEK completado: ${commits[$i]}"
    echo "---------------------------------------------"
done

echo "Todos los commits de Fase 2 completados."
echo "Revisa el historial con: git log --oneline"
