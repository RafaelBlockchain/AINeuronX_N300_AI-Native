# ============================================
# OP1 - NOMINAL
# 0.80V / 500MHz / 75C
# ============================================

set_operating_conditions NOMINAL_0P80V_75C

create_clock -name clk_tile -period 2.000 [get_ports clk]

set_clock_uncertainty 0.10 [get_clocks clk_tile]
set_clock_transition 0.05 [get_clocks clk_tile]

set_clock_latency -source 0.18 [get_clocks clk_tile]
set_clock_latency -late   0.30 [get_clocks clk_tile]

set_input_delay  0.22 -clock clk_tile [all_inputs]
set_output_delay 0.22 -clock clk_tile [all_outputs]

set_false_path -through [get_cells tile_dvfs_if*]
