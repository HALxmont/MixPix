# MixPix Project

- Dummy project Pre-Check: [30/08/2022](https://github.com/HALxmont/MixPix/blob/main/precheck_results/30_AUG_2022___21_52_52/logs/precheck.log)
- The list of pins is [HERE](https://docs.google.com/spreadsheets/d/1lk2tjdau-jsVaK7oEaSVmgTM1Ike2VApzto3_pZgkCU/edit?usp=sharing)



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
- WB slave address registers

| Register | Address Value |
| --- | --- |
| PXL_START_I_ADDR | 0x3000 0000 |
| PXL_DONE_I_ADDR | 0x3000 0004 |
| LOC_TIMERM_I_ADDR | 0x3000 0008 |
| ADJ_TIMER_M_I_ADDR | 0x3000 000C |
| DATA_IN_ADDR | 0x3000 0010 |
| LOC_MAX_CLK_ADDR | 0x3000 0014 |
| ADJ_MAX_CLK_ADDR | 0x3000 0018 |
| DATA_OUT_ADDR | 0x3000 001C |

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
- WB slave address registers

| Register | Address Value |
| --- | --- |
| REG_CE_D | 0x3000 0020 |
| REG_CE_D2 | 0x3000 0024 |
| REG_CE_D3 | 0x3000 0028 |
| GPIO_START | 0x3000 002C |
| LOGIC_ANALYZER_START | 0x3000 0030 |
| DATA_IN | 0x3000 0034 |
| REG_DATA_SEL | 0x3000 0038 |
| REG_D | 0x3000 003C |
| DATA_OUT_ADDR | 0x3000 0040 |





