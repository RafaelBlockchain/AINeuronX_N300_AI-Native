# ============================================
# OP0 - TURBO
# 0.90V / 600MHz / 85C
# ============================================

set_operating_conditions TURBO_0P90V_85C

create_clock -name clk_tile -period 1.667 [get_ports clk]

set_clock_uncertainty 0.12 [get_clocks clk_tile]
set_clock_transition 0.06 [get_clocks clk_tile]

set_clock_latency -source 0.20 [get_clocks clk_tile]
set_clock_latency -late   0.35 [get_clocks clk_tile]

set_input_delay  0.25 -clock clk_tile [all_inputs]
set_output_delay 0.25 -clock clk_tile [all_outputs]

set_false_path -through [get_cells tile_dvfs_if*]

