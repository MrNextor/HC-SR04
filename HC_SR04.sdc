create_clock -period 100.0MHz -name {CLK} [get_ports {CLK}]

derive_clock_uncertainty

set_false_path -from [get_ports {I_EN I_ECHO RST_n}]   -to [all_clocks]
set_false_path -from [get_clocks {CLK}] -to [get_ports {O_HEX[*] O_MUX_HEX[*] O_TRIG O_FL}]