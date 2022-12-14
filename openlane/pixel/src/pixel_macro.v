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
`include "/home/mxmont/Documents/Universidad/IC-UBB/MixPix/CARAVEL_WRAPPER/MixPix/openlane/pixel/src/Pixel.v"
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
    input pxl_start_in_ext,
    input pxl_start_out,
    output pxl_done
);

    wire clk;
    wire rst;

    //------ Pixel FSM control reg
    reg [24:0] control_reg_pxl_fsm;
    
    
    //------ Pixel FSM wires
 
    wire [3:0] wire_pxl_q;
    wire wire_loc_timer_en, wire_adj_timer_en;
    wire wire_s_p1, wire_s_p2, wire_s1, wire_s2, wire_s1_inv, wire_s2_inv;
    wire wire_v_b0, wire_v_b1;
    wire wire_sh;
    wire wire_pxl_done_o;
    wire wire_loc_timer_max, wire_adj_timer_max;
    wire wire_kernel_done_o;

    wire wire_pxl_start_i;
    wire wire_pxl_done_i;
    wire wire_loc_timer_m_i;
    wire wire_adj_timer_m_i;
    wire [9:0] wire_loc_max_clk; 
    wire [9:0] wire_adj_max_clk;

    wire wire_clk_in_ext;
    wire wire_clk_in_wb;
    wire [1:0] wire_clk_sel;
    wire wire_clk_out;
    wire wire_reset_in_ext; 
    wire wire_reset_in_wb;
    wire [1:0] wire_reset_sel;
    wire wire_reset_out; 
    wire wire_pxl_start_in_ext; 
    wire wire_pxl_start_in_wb; 
    wire [1:0] wire_pxl_start_sel; 
    wire wire_pxl_start_out;



    //------ PIXEL FSM wires interconnection to Caravel LA   

    //in and outs are relative to the macros
    //https://github.com/efabless/caravel_user_project/blob/main/verilog/dv/README.md

    //reg_la0_oenb = reg_la0_iena = 0xFF000000;    // [31:0]  OUTPUTS (00, 24bits)  INPUTS(FF, last 8bits)
    assign wire_pxl_q = la_data_out[3:0];            
    assign wire_loc_timer_en = la_data_out[4];         
    assign wire_adj_timer_en = la_data_out[5];       
    assign wire_s_p1 = la_data_out[6];               
    assign wire_s_p2 = la_data_out[7];               
    assign wire_s1 = la_data_out[8];                 
    assign wire_s2 = la_data_out[9];                 
    assign wire_s1_inv = la_data_out[10];            
    assign wire_s2_inv = la_data_out[11];            
    assign wire_v_b0 = la_data_out[12];              
    assign wire_v_b1 = la_data_out[13];              
    assign wire_sh = la_data_out[14];                
    assign wire_pxl_done_o = la_data_out[15];        
    assign wire_loc_timer_max = la_data_out[16];     
    assign wire_adj_timer_max = la_data_out[17];     
    assign wire_kernel_done_o = la_data_out[18];     
    assign wire_clk_out = la_data_out[19];            
    assign wire_reset_out = la_data_out[20];         
    assign wire_pxl_start_out = la_data_out[21];      22,23 -> 0

    //1byte per input (32bit RiscV)
    assign wire_clk_in_ext = la_data_in[24];       //in 24,25,26,26 -> F
    assign wire_clk_in_wb = la_data_in[28];        //in 28,29,30,31 -> F = >   0xFF000000  END [31:0]


    //begin [63:32]
    assign wire_clk_sel = la_data_in[33:32];       //in 32,33,34,35 -> F
    assign wire_reset_in_ext = la_data_in[36];     //in 36,37,38,39 -> F
    assign wire_reset_in_wb = la_data_in[40];      //in 40,41,42,43 -> F
    assign wire_reset_sel = la_data_in[45:44];     //in 44,45,46,47 -> F   
    assign wire_pxl_start_in_ext = la_data_in[48]; //in 48,49,50,51 -> F
    assign wire_pxl_start_in_wb = la_data_in[52];  //in 52,53,54,55 -> F
    assign wire_pxl_start_sel = la_data_in[58:57]; //in 56,57,58,59 -> F
                                                    // 60,61,62,63 free bits of the last byte 
                                                    //0x-FFFFFFF
                                                    //reg_la1_oenb = reg_la1_iena = 0x0FFFFFFF;



    //79
    assign wire_pxl_start_i = la_data_out[79];      //in
    assign wire_pxl_done_i = la_data_out[80];       //in
    assign wire_loc_timer_m_i = la_data_out[81];    //in
    assign wire_adj_timer_m_i = la_data_out[82];    //in    F



  //------ PIXEL FSM wires interconnection to control register
    assign wire_loc_max_clk = control_reg_pxl_fsm[13:4];
    assign wire_adj_max_clk = control_reg_pxl_fsm[23:14];

    
 
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
    .sh(wire_sh),
    .pxl_done_o(wire_pxl_done_o),
    .loc_timer_max(wire_loc_timer_max),
    .loc_max_clk(wire_loc_max_clk), 
    .adj_timer_max(wire_adj_timer_max),
    .adj_max_clk(wire_adj_max_clk),
    .pxl_done_i(wire_pxl_done_i), 
    .pxl_q(wire_pxl_q),
    .kernel_done_o(wire_kernel_done_o),
    .clk_in_ext(wire_clk_in_ext), 
    .clk_in_wb(wire_clk_in_wb), 
    .clk_sel(wire_clk_sel), 
    .clk_out(wire_clk_out), 
    .reset_in_ext(wire_reset_in_ext), 
    .reset_in_wb(wire_reset_in_wb), 
    .reset_sel(wire_reset_sel), 
    .reset_out(wire_reset_out), 
    .pxl_start_in_ext(wire_pxl_start_in_ext), 
    .pxl_start_in_wb(wire_pxl_start_in_wb), 
    .pxl_start_sel(wire_pxl_start_sel), 
    .pxl_start_out(wire_pxl_start_out)
    );

endmodule

`default_nettype wire
