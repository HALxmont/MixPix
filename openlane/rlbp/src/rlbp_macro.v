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
    output [2:0] irq
);

    wire clk;
    wire rst;


    //---------RLBP Regs
    reg reg_ce_d1;
    reg reg_ce_d2;
    reg reg_ce_d3;
    reg reg_gpio_start;
    reg reg_logic_analyzer_start;
    reg reg_data_in;

    reg [1:0] reg_data_sel; 
    reg [3:0] reg_d;



    //------ RLBP wires

    wire wire_reset_fsm;
    wire wire_rlbp_done;
    wire wire_q1_3, wire_q1_2, wire_q1_1, wire_q2_3, wire_q2_2, wire_q2_1, wire_q3_3, wire_q3_2, wire_q3_1;
    wire [3:0] wire_data_out;
    wire [1:0] wire_control_signals;




    //------ RLBP wires interconnection to Caravel LA
    assign wire_reset_fsm = la_data_out[22];
    assign wire_rlbp_done = la_data_out[23];
    assign wire_q1_3 = la_data_out[24];
    assign wire_q1_2 = la_data_out[25];
    assign wire_q1_1 = la_data_out[26];
    assign wire_q2_3 = la_data_out[27];
    assign wire_q2_2 = la_data_out[28];
    assign wire_q2_1 = la_data_out[29];
    assign wire_q3_3 = la_data_out[30];
    assign wire_q3_2 = la_data_out[31];
    assign wire_q3_1 = la_data_out[32];
    assign wire_control_signals = la_data_out[36:33];
    //wire_data_out trougth WB


    //------ RLBP ADDRs table (WSB)

    localparam REG_CE_D1= 32;
    localparam REG_CE_D2 = 36;
    localparam REG_CE_D3 = 40;
    localparam GPIO_START = 44;
    localparam LOGIC_ANALYZER_START = 48;
    localparam DATA_IN = 52;
    localparam REG_DATA_SEL = 54;
    localparam REG_D = 58;
    localparam DATA_OUT_ADDR = 62;

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

always@(posedge clk) begin
		if(rst) begin

            reg_ce_d1 <= 0;
            reg_ce_d2 <= 0;
            reg_ce_d3 <= 0;
            reg_gpio_start <= 0;
            reg_logic_analyzer_start <= 0;
            reg_data_in <= 0; 
            reg_data_sel <= 0;
            reg_d <= 0;

            rdata <= 0; 
            wbs_done <= 0;
		end
		else begin
			wbs_done <= 0;

            //WB SLAVE INTERFACE
			if (valid && addr_valid)  begin  
			    case(wbs_adr_i[7:0])  

                    REG_CE_D1: begin
                        if(wstrb[0])
                            reg_ce_d1 <= wdata[0];
                    end

                    REG_CE_D2: begin
                        if(wstrb[0])
                            reg_ce_d2 <= wdata[0];
                    end       

                    REG_CE_D3: begin
                        if(wstrb[0])
                            reg_ce_d3 <= wdata[0];
                    end

                    GPIO_START:  begin
                        if(wstrb[0])
                            reg_gpio_start <= wdata[0];
                    end

                    LOGIC_ANALYZER_START: begin
                        if(wstrb[0])
                            reg_logic_analyzer_start <= wdata[0];
                    end

                    DATA_IN: begin
                        if(wstrb[0])
                            reg_data_in <= wdata[9:0];  
                    end

                    REG_DATA_SEL: begin
                        if(wstrb[0])
                            reg_data_sel <= wdata[1:0];  
                    end

                    REG_D:  begin	
                        if(wstrb[0])
                            reg_d <= wdata[3:0];  
                    end

                    DATA_OUT_ADDR: begin 
                        rdata <= wire_data_out;
                    end

                    default: ;

				endcase

 			 wbs_done <= 1; 	
      end
    
    end 

 end



// ------- CUSTOM MODULE INSTANTIATION ----- //

rlbp rlbp_inst0 (
    .clk(clk),
    .ce_d1(reg_ce_d1),
    .ce_d2(reg_ce_d2),
    .ce_d3(reg_ce_d3),
    .reset(rst),
    .reset_fsm(wire_reset_fsm),
    .gpio_start(reg_gpio_start),
    .logic_analyzer_start(reg_logic_analyzer_start),
    .control_signals(wire_control_signals),
    .rlbp_done(wire_rlbp_done),
    .data_in(reg_data_in),
    .data_sel(reg_data_sel),
    .data_out(wire_data_out),
    .d(reg_d),
    .q1_3(wire_q1_3),
    .q1_2(wire_q1_2),
    .q1_1(wire_q1_1),
    .q2_3(wire_q2_3),
    .q2_2(wire_q2_2), 
    .q2_1(wire_q2_1), 
    .q3_3(wire_q3_3), 
    .q3_2(wire_q3_2), 
    .q3_1(wire_q3_1)
);


endmodule

`default_nettype wire
