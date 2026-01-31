
#!/bin/bash
# run_runtime.sh — corre la simulación completa y guarda resultados

echo "Iniciando simulación AINeuronX..."
vvp sim_aineuronx.out | tee simulation.log

echo "Simulación completada. Logs en simulation.log"
