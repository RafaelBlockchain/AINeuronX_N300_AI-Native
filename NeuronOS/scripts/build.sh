#!/bin/bash
# Compila todo el runtime de NeuronOS

# Crear carpeta de bin si no existe
mkdir -p ../bin

echo "Compilando NeuronOS runtime..."
g++ -std=c++17 -I../include ../src/*.cpp -o ../bin/neuronos_runtime

if [ $? -eq 0 ]; then
    echo "Compilación completada correctamente."
else
    echo "Error en compilación."
    exit 1
fi
