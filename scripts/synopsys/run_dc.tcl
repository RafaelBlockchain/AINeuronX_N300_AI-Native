read_verilog ../src/**/*.sv
link

source ../scripts/constraints/AINeuronX_N200.sdc

compile_ultra

report_timing
report_area
report_power

write -format verilog -hierarchy -output AINeuronX_N200_netlist.v
