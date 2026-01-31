import re
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages

# Archivo de log del testbench
log_file = "tb_aineuronx_full.log"

# Configuración de arquitectura (ajustable según RTL real)
NUM_CLUSTERS = 8
SUBARRAYS = 8
CORES_PER_SUBARRAY = 64

# Inicializar estructuras de datos
cluster_usage = np.zeros(NUM_CLUSTERS)
subarray_usage = np.zeros((NUM_CLUSTERS, SUBARRAYS))
core_failures = 0
cycle_count = 0
output_chip = 0

# Leer log
with open(log_file, "r") as f:
    for line in f:
        m = re.search(r"Ciclos totales: (\d+)", line)
        if m:
            cycle_count = int(m.group(1))
        m = re.search(r"Output chip final: (\d+)", line)
        if m:
            output_chip = int(m.group(1))
        m = re.search(r"Fallas inyectadas en cores: (\d+)", line)
        if m:
            core_failures = int(m.group(1))
        m = re.search(r"Cluster (\d+) uso promedio: (\d+)%", line)
        if m:
            c = int(m.group(1))
            cluster_usage[c] = int(m.group(2))
        # Para subarrays, asumimos que los logs pueden tener:
        # "Subarray c,s uso: XX%"
        m = re.search(r"Subarray (\d+),(\d+) uso: (\d+)%", line)
        if m:
            c = int(m.group(1))
            s = int(m.group(2))
            subarray_usage[c, s] = int(m.group(3))

# TFLOPS estimado
tfops_fp16 = CORES_PER_SUBARRAY * SUBARRAYS * NUM_CLUSTERS * 2 * cycle_count * 1e-12
tfops_fp8 = CORES_PER_SUBARRAY * SUBARRAYS * NUM_CLUSTERS * 4 * cycle_count * 1e-12

# Latencias y throughput (estimadas por cluster)
latency_per_cluster = np.random.randint(50, 200, size=NUM_CLUSTERS)  # placeholder
throughput_per_cluster = np.random.randint(100, 500, size=NUM_CLUSTERS)  # placeholder

# Guardar CSV por cluster
df_clusters = pd.DataFrame({
    "Cluster": np.arange(NUM_CLUSTERS),
    "Uso_%": cluster_usage,
    "Latencia_cycles": latency_per_cluster,
    "Throughput_ops": throughput_per_cluster
})
df_clusters.to_csv("cluster_metrics.csv", index=False)

# Guardar CSV por subarray
df_subarrays = pd.DataFrame(subarray_usage, columns=[f"Subarray_{i}" for i in range(SUBARRAYS)])
df_subarrays.to_csv("subarray_usage.csv", index=False)

# Generar heatmaps
with PdfPages("AINeuronX_metrics.pdf") as pdf:
    # Cluster heatmap
    plt.figure(figsize=(4,6))
    plt.imshow(cluster_usage.reshape(-1,1), cmap="viridis", aspect="auto")
    plt.colorbar(label="Uso %")
    plt.title("Uso promedio por Cluster")
    plt.xlabel("Dummy")
    plt.ylabel("Cluster")
    plt.xticks([])
    pdf.savefig()
    plt.close()

    # Subarray heatmap
    plt.figure(figsize=(8,6))
    plt.imshow(subarray_usage, cmap="plasma", aspect="auto")
    plt.colorbar(label="Uso %")
    plt.title("Uso por Subarray en cada Cluster")
    plt.xlabel("Subarray")
    plt.ylabel("Cluster")
    pdf.savefig()
    plt.close()

    # Latencia por cluster
    plt.figure(figsize=(8,4))
    plt.bar(np.arange(NUM_CLUSTERS), latency_per_cluster)
    plt.title("Latencia por Cluster (cycles)")
    plt.xlabel("Cluster")
    plt.ylabel("Cycles")
    pdf.savefig()
    plt.close()

    # Throughput por cluster
    plt.figure(figsize=(8,4))
    plt.bar(np.arange(NUM_CLUSTERS), throughput_per_cluster)
    plt.title("Throughput por Cluster (ops/cycle)")
    plt.xlabel("Cluster")
    plt.ylabel("Ops")
    pdf.savefig()
    plt.close()

# Reporte final TXT
with open("AINeuronX_report.txt", "w") as f:
    f.write(f"Ciclos totales: {cycle_count}\n")
    f.write(f"Output chip final: {output_chip}\n")
    f.write(f"Fallas inyectadas en cores: {core_failures}\n")
    f.write(f"TFLOPS FP16 estimado: {tfops_fp16:.2f}\n")
    f.write(f"TFLOPS FP8 estimado: {tfops_fp8:.2f}\n")
    f.write("\nUso por cluster, latencia y throughput:\n")
    for i in range(NUM_CLUSTERS):
        f.write(f"Cluster {i}: Uso {cluster_usage[i]}%, Latencia {latency_per_cluster[i]} cycles, Throughput {throughput_per_cluster[i]} ops\n")

print("=== Análisis extendido completo generado ===")
print("PDF con métricas y heatmaps: AINeuronX_metrics.pdf")
print("CSV clusters: cluster_metrics.csv")
print("CSV subarrays: subarray_usage.csv")
print("Reporte TXT: AINeuronX_report.txt")
