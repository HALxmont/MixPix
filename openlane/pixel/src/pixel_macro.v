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


module pixel_macro #(
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
    input pxl_start_in_path,
    input pxl_start_out_path,
    output pxl_done
);

    wire clk;
    wire rst;

    //------ Pixel FSM control reg
    reg [24:0] control_reg_pxl_fsm;
    
    
    //------ Pixel FSM wires

	wire  [3:0] wire_pxl_q, wire_data_sel;
	wire  wire_loc_timer_en, wire_adj_timer_en;
    wire wire_s_p1, wire_s_p2, wire_s1, wire_s2, wire_s1_inv, wire_s2_inv;
    wire wire_v_b0, wire_v_b1;
    wire wire_pxl_done_o, wire_loc_timer_max;
    wire wire_adj_timer_max;
    wire wire_kernel_done_o;
	wire [15:0] wire_data_out;  

    wire wire_pxl_start_i;
    wire wire_pxl_done_i;
    wire wire_loc_timer_m_i;
    wire wire_adj_timer_m_i;
    wire wire_data_in;
    wire [9:0] wire_loc_max_clk; 
    wire [9:0] wire_adj_max_clk;




    //------ PIXEL FSM wires interconnection to Caravel LA
    assign wire_pxl_q = la_data_out[3:0];
    assign wire_data_sel = la_data_out[7:4];
    assign wire_loc_timer_en = la_data_out[8];
    assign wire_adj_timer_en = la_data_out[9];
    assign wire_s_p1 = la_data_out[10];
    assign wire_s_p2 = la_data_out[11];
    assign wire_s1 = la_data_out[12];
    assign wire_s2 = la_data_out[13];
    assign wire_s1_inv = la_data_out[14];
    assign wire_s2_inv = la_data_out[15];
    assign wire_v_b0 = la_data_out[16];
    assign wire_v_b1 = la_data_out[17];
    assign wire_pxl_done_o = la_data_out[18];
    assign wire_loc_timer_max = la_data_out[19];
    assign wire_adj_timer_max = la_data_out[20];
    assign wire_kernel_done_o = la_data_out[21];

  //------ PIXEL FSM wires interconnection to control register
    assign wire_pxl_start_i = control_reg_pxl_fsm[0];
    assign wire_pxl_done_i = control_reg_pxl_fsm[1];
    assign wire_loc_timer_m_i = control_reg_pxl_fsm[2];
    assign wire_adj_timer_m_i = control_reg_pxl_fsm[3];
    assign wire_data_in = control_reg_pxl_fsm[4];
    assign wire_loc_max_clk = control_reg_pxl_fsm[14:5];
    assign wire_adj_max_clk = control_reg_pxl_fsm[24:15];

    
 
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
            control_reg_pxl_fsm <= 0;
            rdata <= 0; 
            wbs_done <= 0;
		end

		else begin
			wbs_done <= 0;

            //WB SLAVE INTERFACE
			if (valid && addr_valid) begin  
                rdata <= {{7{1'b0}}, control_reg_pxl_fsm};  //fill 32 bits

                if(wstrb[0]) begin
                    control_reg_pxl_fsm <= wdata[24:0];
                end
            end	
        end
end 



// ------- CUSTOM MODULE INSTANTIATION ----- //
pixel pixel_fsm0 (
    .clk(clk),
    .reset(rst),
    .pxl_start_i(wire_pxl_start_i),
    .loc_timer_m_i(wire_loc_timer_m_i),
    .loc_timer_en(wire_loc_timer_en), 
    .adj_timer_m_i(wire_adj_timer_m_i), 
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
    .loc_max_clk(wire_loc_max_clk), 
    .adj_timer_max(wire_adj_timer_max),
    .adj_max_clk(wire_adj_max_clk),
    .pxl_done_i(wire_pxl_done_i), 
    .pxl_q(wire_pxl_q),
    .kernel_done_o(wire_kernel_done_o),
    .data_in(wire_data_in), 
    .data_sel(wire_data_sel),
    .data_out(wire_data_out) 
    );


endmodule

`default_nettype wire
