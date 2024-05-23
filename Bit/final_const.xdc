set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports PWM1]
set_property IOSTANDARD LVCMOS33 [get_ports PWM2]


set_property PACKAGE_PIN W5 [get_ports clk]
set_property PACKAGE_PIN A14 [get_ports PWM1]
set_property PACKAGE_PIN A16 [get_ports PWM2]


set_property PACKAGE_PIN V17 [get_ports {state[0]}]
set_property PACKAGE_PIN V16 [get_ports {state[1]}]
set_property PACKAGE_PIN W16 [get_ports {state[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state[0]}]
