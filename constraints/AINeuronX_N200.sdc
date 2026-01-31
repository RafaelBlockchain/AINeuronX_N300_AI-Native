set_units -time ns -capacitance pF -current mA

create_clock -name clk -period 1.0 [get_ports clk]   ;# 1 GHz target
set_clock_uncertainty 0.05 [get_clocks clk]

set_input_delay  0.2 -clock clk [all_inputs]
set_output_delay 0.2 -clock clk [all_outputs]

set_load 0.05 [all_outputs]

set_max_fanout 16 [current_design]
