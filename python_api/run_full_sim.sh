#!/bin/bash
# run_full_sim.sh — Ejecuta toda la simulación avanzada

echo "Ejecutando simulación completa AINeuronX..."
vvp sim_aineuronx_full.out | tee simulation_full.log

echo "Simulación terminada. Logs guardados en simulation_full.log"
