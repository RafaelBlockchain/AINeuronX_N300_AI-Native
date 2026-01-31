# Clock
create_clock -name core_clk -period 1.0 [get_ports clk]

# Uncertainty
set_clock_uncertainty 0.1 [get_clocks core_clk]

# Reset
set_false_path -from [get_ports rst_n]

# IO constraints (placeholder)
set_input_delay  0.2 -clock core_clk [all_inputs]
set_output_delay 0.2 -clock core_clk [all_outputs]

# Multicycle MAC pipeline
set_multicycle_path 4 -from [get_cells *MAC*] -to [get_cells *MAC*]
