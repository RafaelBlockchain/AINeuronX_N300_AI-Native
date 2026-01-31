# ============================================
# False Paths (STA v1)
# ============================================

# DVFS handshake (control-only)
set_false_path \
    -from [get_pins tile_power_ctrl/dvfs_level*] \
    -to   [get_pins tile_dvfs_if/dvfs_mode*]

# Thermal signals (async sensor domain)
set_false_path \
    -from [get_pins tile_thermal/thermal_state*] \
    -to   [get_pins tile_power_ctrl/*]

# Metrics are observational only
set_false_path \
    -from [get_cells tile_metrics*] \
    -to   [all_registers]
