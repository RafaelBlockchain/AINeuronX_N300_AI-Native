#!/bin/bash
# Ejecuta el runtime de NeuronOS y guarda logs

# Crear carpeta de logs si no existe
mkdir -p ../logs

echo "Ejecutando NeuronOS runtime..."
../bin/neuronos_runtime > ../logs/runtime_output.log

if [ $? -eq 0 ]; then
    echo "Ejecución completada. Logs generados en ../logs/runtime_output.log"
else
    echo "Error en ejecución."
    exit 1
fi
