#!/usr/bin/env python3
"""
roofline_vcd.py
Generación de Roofline gráfico a partir de VCD de Verilator
para NoC AINeuronX TILEs, parsing real por jerarquía.
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from vcd.reader import TokenKind, tokenize

# ==========================
# Configuración
VCD_FILE = "obj_noc_full/VTB_NOC_Full.vcd"  # Cambiar al VCD real de simulación
SIZE_X = 32
SIZE_Y = 32

# Jerarquía de señales: Tile[x][y].metrics.signal
SIGNALS = ["mac_fire", "noc_send", "stall"]

# Prefijo jerarquía en VCD
TILE_PREFIX = "dut.fifos"  # Cambiar según tu jerarquía real si difiere

# ==========================
def read_vcd_tiles(vcd_file, signals):
    """Lee VCD y extrae métricas por tile y señal"""
    # Creamos diccionario tile -> señal -> valor
    data = {}
    for x in range(SIZE_X):
        for y in range(SIZE_Y):
            tile_id = f"tile_{x}_{y}"
            data[tile_id] = {sig: 0 for sig in signals}

    # Abrir VCD
    with open(vcd_file, "r") as f:
        for token in tokenize(f):
            if token.kind == TokenKind.CHANGE:
                var_ref = token.ident
                value = int(token.value)
                # Buscar coincidencia en señales
                for sig in signals:
                    if sig in var_ref:
                        # Determinar tile X/Y desde nombre
                        # Se espera nombre tipo dut.tile_x_y.metrics.mac_fire
                        parts = var_ref.split(".")
                        for part in parts:
                            if "tile_" in part:
                                tile_id = part
                                if tile_id in data:
                                    data[tile_id][sig] += value
    return data

# ==========================
# Leer métricas reales
metrics = read_vcd_tiles(VCD_FILE, SIGNALS)

# Crear DataFrame
rows = []
for x in range(SIZE_X):
    for y in range(SIZE_Y):
        tile_id = f"tile_{x}_{y}"
        row = {"tile_x": x, "tile_y": y}
        for sig in SIGNALS:
            row[sig] = metrics[tile_id][sig]
        rows.append(row)

df = pd.DataFrame(rows)
df.rename(columns={"mac_fire": "mac_ops", "noc_send": "noc_packets", "stall": "stall_cycles"}, inplace=True)

# Guardar CSV
df.to_csv("roofline_metrics.csv", index=False)
print("[INFO] CSV guardado: roofline_metrics_real.csv")

# ==========================
# Roofline gráfico
plt.figure(figsize=(12, 6))
sc = plt.scatter(df["noc_packets"], df["mac_ops"], c=df["stall_cycles"], cmap="viridis", s=50)
plt.colorbar(sc, label="Stall cycles")
plt.xlabel("NOC Packets")
plt.ylabel("MAC Operations")
plt.title("AINeuronX NoC Roofline - Tiles (Real VCD)")
plt.grid(True)
plt.savefig("roofline_tiles_real.png")
plt.show()
print("[INFO] Roofline gráfico guardado: roofline_tiles_real.png")
