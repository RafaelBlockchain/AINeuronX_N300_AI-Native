# ============================================
# AINeuronX N200 - Clock Constraints (STA v1)
# ============================================

# Base tile clock
create_clock -name clk_tile -period 2.0 [get_ports clk]
# 500 MHz nominal

# Generated clocks (logical, not physical)
create_generated_clock -name clk_core \
    -source [get_ports clk] \
    -divide_by 1 \
    [get_pins tile_clock_gating/clk_core]

create_generated_clock -name clk_router \
    -source [get_ports clk] \
    -divide_by 1 \
    [get_pins tile_clock_gating/clk_router]

create_generated_clock -name clk_mem \
    -source [get_ports clk] \
    -divide_by 1 \
    [get_pins tile_clock_gating/clk_mem]

create_generated_clock -name clk_metrics \
    -source [get_ports clk] \
    -divide_by 1 \
    [get_pins tile_clock_gating/clk_metrics]

# Clock uncertainty (conservador v1)
set_clock_uncertainty 0.10 [all_clocks]

# Clock transition (placeholder)
set_clock_transition 0.05 [all_clocks]
