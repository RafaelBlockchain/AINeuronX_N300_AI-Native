#!/bin/bash
# Ejecuta el testbench completo
echo "=== Ejecutando simulación completa ==="
vvp tb_aineuronx_full.out > tb_aineuronx_full.log
if [ $? -eq 0 ]; then
    echo "Simulación completada, log generado: tb_aineuronx_full.log"
else
    echo "Error durante la simulación."
    exit 1
fi
