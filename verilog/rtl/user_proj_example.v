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
`include "Pixel.v"
`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

/* Example project for the course Computer Architecture DIEE-UBB */

module user_proj_example #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground
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

    //------ MixPix regs
    reg reg_pxl_start_i;
    reg reg_pxl_done_i;
    reg reg_loc_timer_m_i;
    reg reg_adj_timer_m_i;
    reg reg_data_in;
    reg [9:0] reg_loc_max_clk; 
    reg [9:0] reg_adj_max_clk;
    
    
    //------ MixPix wires
	wire  [3:0] wire_pxl_q, wire_data_sel;
	wire  wire_loc_timer_en, wire_adj_timer_en;

    wire wire_s_p1, wire_s_p2, wire_s1, wire_s2, wire_s1_inv, wire_s2_inv;
    wire wire_v_b0, wire_v_b1;
    wire wire_pxl_done_o, wire_loc_timer_max;
    wire wire_adj_timer_max;
    wire wire_kernel_done_o;
	wire [15:0] wire_data_out;  //

    //------ MixPix wires interconnection to Caravel LA
    assign wire_pxl_q = la_data_out[3:0];
    assign wire_data_sel = la_data_out[6:3];
    assign wire_loc_timer_en = la_data_out[7:6];
    assign wire_adj_timer_en = la_data_out[8:7];
    assign wire_s_p1 = la_data_out[9:8];
    assign wire_s_p2 = la_data_out[10:9];
    assign wire_s1 = la_data_out[11:10];
    assign wire_s2 = la_data_out[12:11];
    assign wire_s1_inv = la_data_out[13:12];
    assign wire_s2_inv = la_data_out[14:13];
    assign wire_v_b0 = la_data_out[15:14];
    assign wire_v_b1 = la_data_out[16:15];
    assign wire_pxl_done_o = la_data_out[17:16];
    assign wire_loc_timer_max = la_data_out[18:17];
    assign wire_adj_timer_max = la_data_out[19:18];
    assign wire_kernel_done_o = la_data_out[20:19];
    //wire_data_out trougth WB

    //------ MixPix ADDRs table (WSB)
    localparam PXL_START_I_ADDR = 0;
    localparam PXL_DONE_I_ADDR = 4;
    localparam LOC_TIMERM_I_ADDR = 8;
    localparam ADJ_TIMER_M_I_ADDR = 12; 
    localparam DATA_IN_ADDR = 16; 
    localparam LOC_MAX_CLK_ADDR = 20;
    localparam ADJ_MAX_CLK_ADDR = 24;
    localparam DATA_OUT_ADDR = 28;

    // ------ WB slave interface
    reg         wbs_done;
    reg  [31:0] rdata; 
    wire [31:0] wdata;
    wire        valid;
    wire [3:0]  wstrb;
    wire        addr_valid;

    // wire [15:0] my_counter_out;

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

            reg_pxl_start_i <= 0;
            reg_pxl_done_i <= 0;
            reg_loc_timer_m_i <= 0;
            reg_adj_timer_m_i <= 0;
            reg_data_in <= 0;
            reg_loc_max_clk <= 0; 
            reg_adj_max_clk <= 0;

            rdata <= 0; 
            wbs_done <= 0;
		end
		else begin
			wbs_done <= 0;

            //WB SLAVE INTERFACE
			if (valid && addr_valid)  begin  
			    case(wbs_adr_i[7:0])  

                    PXL_START_I_ADDR: begin
                        if(wstrb[0])
                            reg_pxl_start_i <= wdata[0];
                    end

                    PXL_DONE_I_ADDR: begin
                        if(wstrb[0])
                            reg_pxl_done_i <= wdata[0];
                    end       

                    LOC_TIMERM_I_ADDR: begin
                        if(wstrb[0])
                            reg_loc_timer_m_i <= wdata[0];
                    end

                    ADJ_TIMER_M_I_ADDR:  begin
                        if(wstrb[0])
                            reg_adj_timer_m_i <= wdata[0];
                    end

                    DATA_IN_ADDR: begin
                        if(wstrb[0])
                            reg_data_in <= wdata[0];
                    end

                    LOC_MAX_CLK_ADDR: begin
                        if(wstrb[0])
                            reg_loc_max_clk <= wdata[9:0];  
                    end

                    ADJ_MAX_CLK_ADDR: begin
                        if(wstrb[0])
                            reg_adj_max_clk <= wdata[9:0];  
                    end

                    DATA_OUT_ADDR:  begin	
                        rdata <= wire_data_out;
                    end

                    default: ;

				endcase

 			 wbs_done <= 1; 
			
      end
    
    end 

 end



// ------- CUSTOM MODULE INSTANTIATION ----- //
pixel pixel_fsm0 (
    .clk(clk),
    .reset(rst),
    .pxl_start_i(reg_pxl_start_i),
    .loc_timer_m_i(reg_loc_timer_m_i),
    .loc_timer_en(wire_loc_timer_en), 
    .adj_timer_m_i(reg_adj_timer_m_i), 
    .adj_timer_en(wire_adj_timer_en),
    .s_p1(wire_s_p1),
    .s_p2(wire_s_p2), 
    .s1(wire_s1),
    .s2(wire_s2),
    .s1_inv(wire_s1_inv),
    .s2_inv(wire_s2_inv),
    .v_b1(wire_v_b1),
    .v_b0(wire_v_b0), 
    .pxl_done_o(wire_pxl_done_o),
    .loc_timer_max(wire_loc_timer_max),
    .loc_max_clk(reg_loc_max_clk), 
    .adj_timer_max(wire_adj_timer_max),
    .adj_max_clk(reg_adj_max_clk),
    .pxl_done_i(reg_pxl_done_i), 
    .pxl_q(wire_pxl_q),
    .kernel_done_o(wire_kernel_done_o),
    .data_in(reg_data_in), 
    .data_sel(wire_data_sel),
    .data_out(wire_data_out) 
    );
endmodule

`default_nettype wire