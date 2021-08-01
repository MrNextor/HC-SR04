# Copyright (C) 2018  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License 
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel FPGA IP License Agreement, or other applicable license
# agreement, including, without limitation, that your use is for
# the sole purpose of programming logic devices manufactured by
# Intel and sold by Intel or its authorized distributors.  Please
# refer to the applicable agreement for further details.

# Quartus Prime: Generate Tcl File for Project
# File: HC_SR04.tcl
# Generated on: Sun Aug 01 17:46:54 2021

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "HC_SR04"]} {
		puts "Project HC_SR04 is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists HC_SR04]} {
		project_open -revision HC_SR04 HC_SR04
	} else {
		project_new -revision HC_SR04 HC_SR04
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "Cyclone V"
	set_global_assignment -name DEVICE 5CSEMA5F31C6
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 18.1.0
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "09:32:08  MAY 13, 2021"
	set_global_assignment -name LAST_QUARTUS_VERSION "18.1.0 Lite Edition"
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
	set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (Verilog)"
	set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation
	set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
	set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
	set_global_assignment -name TIMING_ANALYZER_MULTICORNER_ANALYSIS ON
	set_global_assignment -name NUM_PARALLEL_PROCESSORS ALL
	set_global_assignment -name EDA_TEST_BENCH_ENABLE_STATUS TEST_BENCH_MODE -section_id eda_simulation
	set_global_assignment -name EDA_NATIVELINK_SIMULATION_TEST_BENCH HC_SR04_vlg_tst -section_id eda_simulation
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST ON -section_id eda_simulation
	set_global_assignment -name VERILOG_FILE HC_SR04.v
	set_global_assignment -name VERILOG_FILE hc_sr04_fsm.v
	set_global_assignment -name SYSTEMVERILOG_FILE bcd_encoder.sv
	set_global_assignment -name VERILOG_FILE dynamic_indication.v
	set_global_assignment -name VERILOG_FILE clk_div.v
	set_global_assignment -name SDC_FILE HC_SR04.sdc
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	set_global_assignment -name EDA_TEST_BENCH_NAME HC_SR04_vlg_tst -section_id eda_simulation
	set_global_assignment -name EDA_DESIGN_INSTANCE_NAME NA -section_id HC_SR04_vlg_tst
	set_global_assignment -name EDA_TEST_BENCH_MODULE_NAME HC_SR04_vlg_tst -section_id HC_SR04_vlg_tst
	set_global_assignment -name EDA_TEST_BENCH_FILE simulation/modelsim/HC_SR04.vt -section_id HC_SR04_vlg_tst
	set_location_assignment PIN_AF14 -to CLK
	set_location_assignment PIN_AJ21 -to I_ECHO
	set_location_assignment PIN_AF19 -to O_HEX[0]
	set_location_assignment PIN_AE18 -to O_HEX[1]
	set_location_assignment PIN_AG20 -to O_HEX[2]
	set_location_assignment PIN_AF21 -to O_HEX[3]
	set_location_assignment PIN_AG21 -to O_HEX[4]
	set_location_assignment PIN_AF20 -to O_HEX[5]
	set_location_assignment PIN_AE19 -to O_HEX[6]
	set_location_assignment PIN_AD19 -to O_MUX_HEX[0]
	set_location_assignment PIN_AH20 -to O_MUX_HEX[1]
	set_location_assignment PIN_AH19 -to O_MUX_HEX[2]
	set_location_assignment PIN_AA15 -to RST_n
	set_location_assignment PIN_AG18 -to O_TRIG
	set_location_assignment PIN_AA14 -to I_EN
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to CLK
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to RST_n
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to O_TRIG
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to O_MUX_HEX[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to O_MUX_HEX[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to O_MUX_HEX[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to O_HEX[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to O_HEX[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to O_HEX[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to O_HEX[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to O_HEX[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to O_HEX[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to O_HEX[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to I_ECHO
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to I_EN
	set_location_assignment PIN_V16 -to O_FL
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to O_FL
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
