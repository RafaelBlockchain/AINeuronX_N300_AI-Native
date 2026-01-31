# ============================================
# OP2 - ECO
# 0.70V / 350MHz / 25C
# ============================================

set_operating_conditions ECO_0P70V_25C

create_clock -name clk_tile -period 2.857 [get_ports clk]

set_clock_uncertainty 0.08 [get_clocks clk_tile]
set_clock_transition 0.045 [get_clocks clk_tile]

set_clock_latency -source 0.15 [get_clocks clk_tile]
set_clock_latency -late   0.28 [get_clocks clk_tile]

set_input_delay  0.20 -clock clk_tile [all_inputs]
set_output_delay 0.20 -clock clk_tile [all_outputs]

set_false_path -through [get_cells tile_dvfs_if*]
