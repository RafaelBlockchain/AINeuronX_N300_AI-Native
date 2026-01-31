set TOP AINeuronX_ARRAY_64x64_NOC

read_verilog -sv ../src/**/*.sv
read_upf ../power/AINeuronX_N200.upf
read_sdc ../constraints/AINeuronX_N200.sdc

link
check_design

compile_ultra -gate_clock -no_autoungroup

report_area  > reports/area.rpt
report_timing > reports/timing.rpt
report_power  > reports/power.rpt

write -hierarchy -format verilog -output netlist.v
