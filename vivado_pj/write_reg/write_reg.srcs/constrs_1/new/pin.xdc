create_pblock pblock_hex_top_inst
add_cells_to_pblock [get_pblocks pblock_hex_top_inst] [get_cells -quiet [list hex_top_inst]]
resize_pblock [get_pblocks pblock_hex_top_inst] -add {SLICE_X8Y9:SLICE_X59Y30}
resize_pblock [get_pblocks pblock_hex_top_inst] -add {DSP48_X0Y4:DSP48_X1Y11}
resize_pblock [get_pblocks pblock_hex_top_inst] -add {RAMB18_X1Y4:RAMB18_X2Y11}
resize_pblock [get_pblocks pblock_hex_top_inst] -add {RAMB36_X1Y2:RAMB36_X2Y5}
create_pblock pblock_write_reg_top_inst
add_cells_to_pblock [get_pblocks pblock_write_reg_top_inst] [get_cells -quiet [list write_reg_top_inst]]
resize_pblock [get_pblocks pblock_write_reg_top_inst] -add {SLICE_X6Y108:SLICE_X53Y144}
resize_pblock [get_pblocks pblock_write_reg_top_inst] -add {DSP48_X0Y44:DSP48_X0Y57}
resize_pblock [get_pblocks pblock_write_reg_top_inst] -add {RAMB18_X0Y44:RAMB18_X1Y57}
resize_pblock [get_pblocks pblock_write_reg_top_inst] -add {RAMB36_X0Y22:RAMB36_X1Y28}
set_property PACKAGE_PIN Y18 [get_ports clk]
set_property PACKAGE_PIN M18 [get_ports ds]
set_property PACKAGE_PIN F15 [get_ports key]
set_property PACKAGE_PIN B21 [get_ports rst_n]
set_property PACKAGE_PIN F4 [get_ports sh_cp]
set_property PACKAGE_PIN C2 [get_ports st_cp]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports ds]
set_property IOSTANDARD LVCMOS33 [get_ports key]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports sh_cp]
set_property IOSTANDARD LVCMOS33 [get_ports st_cp]
