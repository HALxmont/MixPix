# README

## Digital Macros: Preliminar Layout (manual placement)

<img src="README/FSM-Physical_design_notes.png" width=50% height=50%>

## Digital Macros, Register Map

### Pixel FSM

- Wires interconnection to Caravel LA

| Pixel FSM ports | Caravel LA out [127:0] |
| --- | --- |
| wire_pxl_q | [3:0] |
| wire_data_sel | [7:4] |
| wire_loc_timer_en | [8] |
| wire_adj_timer_en | [9] |
| wire_s_p1 | [10] |
| wire_s_p2 | [11] |
| wire_s1 | [12] |
| wire_s2 | [13] |
| wire_s1_inv | [14] |
| wire_s2_inv | [15] |
| wire_v_b0 | [16] |
| wire_v_b1 | [17] |
| wire_pxl_done_o | [18] |
| wire_loc_timer_max | [19] |
| wire_adj_timer_max | [20] |
| wire_kernel_done_o | [21] |
- control_reg_pxl_fsm accessible through WB

| control_reg_pxl_fsm[0] | pxl_start_i |
| --- | --- |
| control_reg_pxl_fsm[1] | pxl_done_i |
| control_reg_pxl_fsm[2] | loc_timer_m_i |
| control_reg_pxl_fsm[3] | adj_timer_m_i |
| control_reg_pxl_fsm[4] | data_in |
| control_reg_pxl_fsm[14:5] | loc_max_clk |
| control_reg_pxl_fsm[24:15] | adj_max_clk |

### RLBP FSM

- Wires interconnection to Caravel LA

| RLBP FSM ports | Caravel LA out [127:0] |
| --- | --- |
| wire_reset_fsm | [22] |
| wire_rlbp_done | [23] |
| wire_q1_3 | [24] |
| wire_q1_2 | [25] |
| wire_q1_1 | [26] |
| wire_q2_3 | [27] |
| wire_q2_2 | [28] |
| wire_q2_1 | [29] |
| wire_q3_3 | [30] |
| wire_q3_2 | [31] |
| wire_q3_1 | [32] |
| wire_control_signals | [36:33] |
- control_reg_rlbp_fsm accessible through WB

| control_reg_rlbp_fsm[0] | ce_d1 |
| --- | --- |
| control_reg_rlbp_fsm[1] | ce_d2 |
| control_reg_rlbp_fsm[2] | ce_d3 |
| control_reg_rlbp_fsm[3] | gpio_start |
| control_reg_rlbp_fsm[4] | logic_analyzer_start |
| control_reg_rlbp_fsm[5] | data_in |
| control_reg_rlbp_fsm[7:6] | data_sel |
| control_reg_rlbp_fsm[11:8] | d |
