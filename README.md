# AINeuronX — RTL & NeuronOS Simulation Suite

**Autor:** Rafael González Cortés  
**Proyecto:** AINeuronX — AI-native accelerator + NeuronOS  
**Propósito:** Simulación completa del chip, análisis de performance y generación de métricas para whitepaper/PPA.

# AINeuronX-NeuronOS
AINeuronX es un acelerador de IA de alto rendimiento, escalable a clusters masivos, con soporte FP16 y FP8. Incluye diseño RTL completo, testbenches de simulación, runtime NeuronOS, benchmarks de matrices, documentación técnica y whitepaper. Objetivo: performance, eficiencia y escalabilidad global.
# AINeuronX

Proyecto de acelerador de IA de alto rendimiento con soporte FP16 y FP8, escalable a clusters masivos.

Incluye:
- Diseño RTL completo (Tensor Core Array, L1 Cache, Compute Cluster, Chip)
- Testbench para simulaciones FP16/FP8
- Runtime NeuronOS para ejecución de kernels y scheduling jerárquico
- Benchmarks y métricas de performance
- Documentación técnica y whitepaper


## ⚡ Módulos RTL incluidos

1. **tensor_core_array.v** — Núcleo tensorial principal.  
2. **tensor_subarray.v** — Subarrays de tensor cores.  
3. **l1_cache_adaptive.v** — Cache de primer nivel por core.  
4. **l2_cache.v** — Cache de segundo nivel por cluster.  
5. **compute_cluster.v** — Cluster completo de cómputo.  
6. **memory_controller.v** — Gestión de acceso a DRAM.  
7. **dma_engine.v** — Mueve bloques de datos entre memoria y clusters.  
8. **crossbar_network.v** — Interconexión interna L1/L2 y clusters.  
9. **nvlink_pcie_link.v** — Interconexión externa simulada.  
10. **power_model.v** — Estimación de consumo.  
11. **error_injection.v** — Inyección de fallos para resiliencia.  
12. **clock_reset_gen.v** — Sincronización global.  
13. **aineuronx_chip.v** — Integración de todos los módulos en un chip funcional.

---

## 🧪 Testbench

- **tb_aineuronx_full.v** — Simulación unificada de todo el chip.  
- Soporta FP16 y FP8 nativos.  
- Prefetch adaptativo habilitado.  
- Error injection aleatorio en cores (~1%).  
- Métricas detalladas: ciclos, utilización por cluster/subarray, fallas, output final.

---

## 🏗️ Scripts de automatización

1. **build.sh** — Compila todos los módulos RTL con `iverilog`.  
2. **run_runtime.sh** — Ejecuta el testbench completo y genera log.  
3. **run_analysis.sh** — Procesa el log con Python (`analyze_full.py`) y genera:  
   - PDF con heatmaps por cluster y subarray  
   - CSV de métricas por cluster y subarray  
   - TXT con resumen de ciclos, TFLOPS, fallas y throughput  
4. **run_all.sh** — Ejecuta todo el pipeline completo: build → simulación → análisis.

---

## 📊 Análisis y métricas (`analyze_full.py`)

- Genera **heatmaps de utilización**, TFLOPS FP16/FP8, latencias y throughput.  
- Produce **archivos PDF y CSV** listos para whitepaper y PPA.  
- Permite extensión para análisis por core si se requiere mayor granularidad.

---

## 🚀 Cómo ejecutar

1. Clonar repositorio

2. Hacer pipeline completo:
chmod +x *.sh
./run_all.sh

3- Resultados generados en la raíz:
AINeuronX_metrics.pdf → Heatmaps y gráficos

cluster_metrics.csv → Métricas por cluster

subarray_usage.csv → Métricas por subarray

AINeuronX_report.txt → Resumen completo

📝 Notas técnicas
Arquitectura simulada: 8 clusters × 8 subarrays × 64 cores/subarray

Precision nativa: FP16 y FP8

Prefetch adaptativo activo para análisis de throughput

Base lista para integración con futuros scripts de benchmarking MLPerf y PPA real.

📌 Recomendaciones
Ejecutar primero build.sh para validar compilación RTL.

Revisar logs en tb_aineuronx_full.log para depuración de simulación.

Mantener python_api/analyze_full.py actualizado con cambios en log.

Proyecto AINeuronX — Simulación avanzada de AI-native accelerator + NeuronOS

---

# AINeuronX

## Descripción
AINeuronX es un acelerador de IA de próxima generación diseñado con arquitectura “AI-native silicon”, optimizado para FP16/FP8, alto paralelismo, prefetch adaptativo y escalabilidad multi-cluster. Incluye un stack completo de software NeuronOS para ejecución de kernels, gestión de memoria, scheduling jerárquico y control de hardware.

Este repositorio incluye:
- Módulos RTL simulados del chip completo.
- Testbench avanzado con error injection y métricas detalladas.
- Scripts Python para análisis de logs y generación de heatmaps, TFLOPS y reportes.
- Infraestructura lista para FP16 y FP8, prefetch adaptativo y resiliencia de cores.

---

## Contenido del Repositorio

### RTL Modules
- `tensor_core_array.v` — Tensor Core Array principal.
- `tensor_subarray.v` — Subarrays de 64 cores cada uno.
- `l1_cache_adaptive.v` — Cache L1 con prefetch dinámico.
- `compute_cluster.v` — Cluster de cómputo completo.
- `aineuronx_chip.v` — Chip completo integrado.
- Módulos adicionales recomendados:
  - `l2_cache.v` — Cache L2 por cluster.
  - `memory_controller.v` — Control de acceso a DRAM.
  - `dma_engine.v` — Movimientos de bloques de datos.
  - `crossbar_network.v` — Interconexión L1/L2 y clusters.
  - `nvlink_pcie_link.v` — Simulación de enlaces externos.
  - `power_model.v` — Estimación de consumo y gestión de energía.
  - `error_injection.v` — Inyección de fallos para resiliencia.
  - `clock_reset_gen.v` — Generador de reloj y reset sincronizado.

---

### Testbench
- `tb_aineuronx_full.v` — Testbench completo del chip:
  - Integración de todos los módulos RTL.
  - Error injection aleatorio (~1% cores).
  - Métricas detalladas de utilización por cluster y subarray.
  - Soporte FP16/FP8 y prefetch adaptativo.
  - Reporte de ciclos, output final, fallas inyectadas y utilización promedio.

---

### Scripts Python
- `python_api/analyze_full.py` — Analiza logs del testbench:
  - Genera heatmaps de utilización.
  - Calcula TFLOPS FP16 / FP8 sostenidos.
  - Latencias y throughput por cluster.
  - Exportación a CSV / PDF para whitepaper y PPA.

- `python_api/build.sh` — Compila y prepara entorno.
- `python_api/run_runtime.sh` — Ejecuta simulación completa.
- `python_api/run_python_tests.sh` — Corre scripts de análisis automáticamente.

---

### Ejecución
1. Simular RTL con tu simulator preferido (Vivado, ModelSim, etc.):
```bash
# Desde la carpeta testbench
vlog ../rtl/*.v
vsim tb_aineuronx_full



