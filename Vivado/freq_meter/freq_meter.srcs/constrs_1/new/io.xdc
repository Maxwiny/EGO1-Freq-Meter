set_property IOSTANDARD LVCMOS33 [get_ports {o_seg1[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg1[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg1[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg1[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg1[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg1[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg1[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg1[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg2[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg2[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg2[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg2[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg2[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg2[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg2[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg2[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg_pos[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg_pos[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg_pos[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg_pos[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg_pos[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg_pos[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg_pos[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg_pos[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports rstn]
set_property PACKAGE_PIN P17 [get_ports clk]
set_property PACKAGE_PIN P15 [get_ports rstn]
set_property PACKAGE_PIN G6 [get_ports {o_seg_pos[0]}]
set_property PACKAGE_PIN E1 [get_ports {o_seg_pos[1]}]
set_property PACKAGE_PIN F1 [get_ports {o_seg_pos[2]}]
set_property PACKAGE_PIN G1 [get_ports {o_seg_pos[3]}]
set_property PACKAGE_PIN H1 [get_ports {o_seg_pos[4]}]
set_property PACKAGE_PIN C1 [get_ports {o_seg_pos[5]}]
set_property PACKAGE_PIN C2 [get_ports {o_seg_pos[6]}]
set_property PACKAGE_PIN G2 [get_ports {o_seg_pos[7]}]
set_property PACKAGE_PIN D4 [get_ports {o_seg1[0]}]
set_property PACKAGE_PIN E3 [get_ports {o_seg1[1]}]
set_property PACKAGE_PIN D3 [get_ports {o_seg1[2]}]
set_property PACKAGE_PIN F4 [get_ports {o_seg1[3]}]
set_property PACKAGE_PIN F3 [get_ports {o_seg1[4]}]
set_property PACKAGE_PIN E2 [get_ports {o_seg1[5]}]
set_property PACKAGE_PIN D2 [get_ports {o_seg1[6]}]
set_property PACKAGE_PIN H2 [get_ports {o_seg1[7]}]
set_property PACKAGE_PIN B4 [get_ports {o_seg2[0]}]
set_property PACKAGE_PIN A4 [get_ports {o_seg2[1]}]
set_property PACKAGE_PIN A3 [get_ports {o_seg2[2]}]
set_property PACKAGE_PIN B1 [get_ports {o_seg2[3]}]
set_property PACKAGE_PIN A1 [get_ports {o_seg2[4]}]
set_property PACKAGE_PIN B3 [get_ports {o_seg2[5]}]
set_property PACKAGE_PIN B2 [get_ports {o_seg2[6]}]
set_property PACKAGE_PIN D5 [get_ports {o_seg2[7]}]


set_property IOSTANDARD LVCMOS33 [get_ports {i_key[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_key[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_key[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_key[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_key[4]}]

set_property PACKAGE_PIN R11 [get_ports {i_key[0]}]
set_property PACKAGE_PIN R17 [get_ports {i_key[1]}]
set_property PACKAGE_PIN R15 [get_ports {i_key[2]}]
set_property PACKAGE_PIN V1 [get_ports {i_key[3]}]
set_property PACKAGE_PIN U4 [get_ports {i_key[4]}]


create_clock	-name SysClk -period 10 -waveform {0 5} [get_ports clk]