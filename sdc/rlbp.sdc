###############################################################################
# Created by write_sdc
# Fri Sep  2 19:59:29 2022
###############################################################################
current_design rlbp
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 10.0000 [get_ports {clk}]
set_clock_transition 0.1500 [get_clocks {clk}]
set_clock_uncertainty 0.2500 clk
set_propagated_clock [get_clocks {clk}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {ce_d1}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {ce_d2}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {ce_d3}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {d[0]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {d[1]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {d[2]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {d[3]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_in}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_sel[0]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_sel[1]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {gpio_start}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {logic_analyzer_start}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {control_signals[0]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {control_signals[1]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_out[0]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_out[1]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_out[2]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_out[3]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {q1_1}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {q1_2}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {q1_3}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {q2_1}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {q2_2}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {q2_3}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {q3_1}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {q3_2}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {q3_3}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {reset_fsm}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {rlbp_done}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.0334 [get_ports {q1_1}]
set_load -pin_load 0.0334 [get_ports {q1_2}]
set_load -pin_load 0.0334 [get_ports {q1_3}]
set_load -pin_load 0.0334 [get_ports {q2_1}]
set_load -pin_load 0.0334 [get_ports {q2_2}]
set_load -pin_load 0.0334 [get_ports {q2_3}]
set_load -pin_load 0.0334 [get_ports {q3_1}]
set_load -pin_load 0.0334 [get_ports {q3_2}]
set_load -pin_load 0.0334 [get_ports {q3_3}]
set_load -pin_load 0.0334 [get_ports {reset_fsm}]
set_load -pin_load 0.0334 [get_ports {rlbp_done}]
set_load -pin_load 0.0334 [get_ports {control_signals[1]}]
set_load -pin_load 0.0334 [get_ports {control_signals[0]}]
set_load -pin_load 0.0334 [get_ports {data_out[3]}]
set_load -pin_load 0.0334 [get_ports {data_out[2]}]
set_load -pin_load 0.0334 [get_ports {data_out[1]}]
set_load -pin_load 0.0334 [get_ports {data_out[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {ce_d1}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {ce_d2}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {ce_d3}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {clk}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {data_in}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {gpio_start}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {logic_analyzer_start}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {reset}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {d[3]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {d[2]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {d[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {d[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {data_sel[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {data_sel[0]}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_fanout 5.0000 [current_design]
