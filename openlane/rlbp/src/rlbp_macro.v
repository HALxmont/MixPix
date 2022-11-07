// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0
`include "rlbp.v"
`default_nettype none


module rlbp_macro #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,


    // IRQ
    output [2:0] irq,

    // ---- Design Specific Ports 

    output serial_data_rlbp_out


    
);

    wire clk;
    wire rst;


    //---------RLBP control register
    reg [11:0] control_reg_rlbp_fsm;

    //------ RLBP wires

    wire wire_reset_fsm;
    wire wire_rlbp_done;
    wire wire_q1_3, wire_q1_2, wire_q1_1, wire_q2_3, wire_q2_2, wire_q2_1, wire_q3_3, wire_q3_2, wire_q3_1;
    wire [3:0] wire_data_out;
    wire [1:0] wire_control_signals;

    wire wire_pxl_done_i;
    wire [7:0] wire_p_data_in;
    wire wire_s_data_out;
    wire wire_ready;

    wire wire_ce_d1;
    wire wire_ce_d2;
    wire wire_ce_d3;
    wire wire_gpio_start;
    wire wire_logic_analyzer_start;
    wire wire_data_in;
    wire [1:0] wire_data_sel; 
    wire [3:0] wire_d;



    //------ RLBP wires interconnection to Caravel LA

    //in and outs are relative to the macros
    //https://github.com/efabless/caravel_user_project/blob/main/verilog/dv/README.md

    //[95:64]
    assign wire_reset_fsm = la_data_out[64];            //out
    assign wire_rlbp_done = la_data_out[65];            //out
    assign wire_q1_3 = la_data_out[66];                 //out
    assign wire_q1_2 = la_data_out[67];                 //out   0
    assign wire_q1_1 = la_data_out[68];                 //out
    assign wire_q2_3 = la_data_out[69];                 //out
    assign wire_q2_2 = la_data_out[70];                 //out
    assign wire_q2_1 = la_data_out[71];                 //out   0
    assign wire_q3_3 = la_data_out[72];                 //out
    assign wire_q3_2 = la_data_out[73];                 //out
    assign wire_q3_1 = la_data_out[74];                 //out
    assign wire_control_signals = la_data_out[78:75];   //out   0
                                                        //5 bytes free. First 3 bytes needs to be set 0
                                                        //0x-----000  ("-" = free to set)


    
     //------ RLBP wires interconnection to RLBP control register
    assign wire_ce_d1 = control_reg_rlbp_fsm[0];
    assign wire_ce_d2 = control_reg_rlbp_fsm[1];
    assign wire_ce_d3 = control_reg_rlbp_fsm[2];
    assign wire_gpio_start = control_reg_rlbp_fsm[3];
    assign wire_logic_analyzer_start = control_reg_rlbp_fsm[4];
    assign wire_data_in = control_reg_rlbp_fsm[5];
    assign wire_data_sel = control_reg_rlbp_fsm[7:6]; 
    assign wire_d = control_reg_rlbp_fsm[11:8];


    // ------ WB slave interface
    reg         wbs_done;
    reg  [31:0] rdata; 
    wire [31:0] wdata;
    wire        valid;
    wire [3:0]  wstrb;
    wire        addr_valid;


    // Wishbone
    assign valid = wbs_cyc_i && wbs_stb_i; 
    assign wstrb = wbs_sel_i & {4{wbs_we_i}};
    assign wbs_dat_o = rdata; // out
    assign wdata = wbs_dat_i; // in
    assign addr_valid = (wbs_adr_i[31:28] == 3) ? 1 : 0;
    assign wbs_ack_o  = wbs_done;

    assign clk = wb_clk_i;
    assign rst = wb_rst_i;

    // Module ports
    assign serial_data_rlbp_out = wire_s_data_out;

always@(posedge clk) begin
		if(rst) begin

            control_reg_rlbp_fsm <= 0;
            rdata <= 0; 
            wbs_done <= 0;
		end

    	else begin
			wbs_done <= 0;

            //WB SLAVE INTERFACE
			if (valid && addr_valid) begin  
                rdata <= {{20{1'b0}}, control_reg_rlbp_fsm};  //fill 32 bits

                if(wstrb[0]) begin
                    control_reg_rlbp_fsm <= wdata[11:0];
                end
            end	
        end
end 


// ------- CUSTOM MODULE INSTANTIATION ----- //

rlbp rlbp_inst0 (
    .clk(clk),
    .ce_d1(wire_ce_d1),
    .ce_d2(wire_ce_d2),
    .ce_d3(wire_ce_d3),
    .reset(rst),
    .reset_fsm(wire_reset_fsm),
    .gpio_start(wire_gpio_start),
    .logic_analyzer_start(wire_logic_analyzer_start),
    .control_signals(wire_control_signals),
    .rlbp_done(wire_rlbp_done),
    .pxl_done_i(wire_pxl_done_i), //
    .data_in(wire_data_in),
    .data_sel(wire_data_sel),
    .data_out(wire_data_out),
    .d(wire_d),
    .q1_3(wire_q1_3),
    .q1_2(wire_q1_2),
    .q1_1(wire_q1_1),
    .q2_3(wire_q2_3),
    .q2_2(wire_q2_2), 
    .q2_1(wire_q2_1), 
    .q3_3(wire_q3_3), 
    .q3_2(wire_q3_2), 
    .q3_1(wire_q3_1),
    .en(wire_en), 
    .p_data_in(wire_p_data_in),  //parallel data in
    .s_data_out(wire_s_data_out), //serial data out
    .ready(wire_ready) //P2S conversion ready
);




endmodule

`default_nettype wire
