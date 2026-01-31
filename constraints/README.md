STA v1 - AINeuronX N200

Orden recomendado:
1) Leer clocks.sdc
2) Leer resets.sdc
3) Leer false_paths.sdc

Suposiciones:
- DVFS tratado como multi-corner, no intra-cycle
- Clock gating reconocido por tool
- Reset asíncrono, de-assert síncrono

Objetivo v1:
- STA limpio
- Sin excepciones ocultas
- Base sólida para sign-off incremental
