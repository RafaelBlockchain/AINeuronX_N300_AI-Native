# ============================================
# OP3 - DEEP ECO
# 0.60V / 200MHz / 0C
# ============================================

set_operating_conditions DEEP_ECO_0P60V_0C

create_clock -name clk_tile -period 5.000 [get_ports clk]

set_clock_uncertainty 0.06 [get_clocks clk_tile]
set_clock_transition 0.04 [get_clocks clk_tile]

set_clock_latency -source 0.12 [get_clocks clk_tile]
set_clock_latency -late   0.25 [get_clocks clk_tile]

# HOLD is hardest here
set_fix_hold [all_clocks]

set_input_delay  0.18 -clock clk_tile [all_inputs]
set_output_delay 0.18 -clock clk_tile [all_outputs]

set_false_path -through [get_cells tile_dvfs_if*]
