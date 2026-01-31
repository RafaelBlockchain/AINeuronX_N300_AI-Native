set TOP AINeuronX_ARRAY_64x64_NOC

read_hdl ../src
read_power_intent -upf ../power/AINeuronX_N200.upf
read_sdc ../constraints/AINeuronX_N200.sdc

elaborate $TOP
synthesize -to_mapped

report area   > reports/area.rpt
report timing > reports/timing.rpt
report power  > reports/power.rpt

write_hdl > netlist.v
