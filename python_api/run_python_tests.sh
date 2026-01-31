#!/bin/bash
# run_python_tests.sh — procesa logs y genera métricas y gráficos

echo "Generando métricas y heatmaps..."
python3 << EOF
import re
import matplotlib.pyplot as plt

# Leer log de simulación
log_file = "simulation.log"
cycles = 0
power = 0
output = 0

with open(log_file, 'r') as f:
    for line in f:
        if "Ciclos:" in line:
            cycles = int(re.search(r'\d+', line).group())
        if "Output chip:" in line:
            numbers = re.findall(r'\d+', line)
            output = int(numbers[0])
            power = int(numbers[1])

print(f"Total ciclos simulados: {cycles}")
print(f"Output chip final: {output}")
print(f"Consumo estimado: {power} W")

# Heatmap de ejemplo de utilización de cores
import numpy as np
matrix_size = 8
heatmap = np.random.randint(50,100,(matrix_size,matrix_size))  # placeholder
plt.imshow(heatmap, cmap='hot', interpolation='nearest')
plt.colorbar(label='Uso (%)')
plt.title("Heatmap de utilización de Tensor Cores")
plt.savefig("heatmap_cores.png")
plt.show()
EOF

echo "Métricas generadas y heatmap guardado en heatmap_cores.png"

