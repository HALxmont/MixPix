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
`include "/home/mxmont/Documents/Universidad/IC-UBB/MixPix/CARAVEL_WRAPPER/MixPix/openlane/rlbp/src/rlbp.v"
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


    input ext_clk,
    input ext_start,
    input ext_reset,

    output clk_o,
    output rst_o,
    output done_o,
    output start_o,
    output data_o,
    output counter_rst,
    output Vd1,
    output Vd2,
    output Sw1,
    output Sw2,
    output Sh,          //check assign
    output Sh_cmp,
    output Sh_rst,

//exponer pdx_a, pdx_b (all in #N)
    output Pd1_a, 
    output Pd1_b,
    output Pd2_a, 
    output Pd2_b,
    output Pd3_a, 
    output Pd3_b,
    output Pd4_a, 
    output Pd4_b,
    output Pd5_a, 
    output Pd5_b,
    output Pd6_a, 
    output Pd6_b,
    output Pd7_a, 
    output Pd7_b,
    output Pd8_a, 
    output Pd8_b,
    output Pd9_a, 
    output Pd9_b,
    output Pd10_a, 
    output Pd10_b,
    output Pd11_a, 
    output Pd11_b,
    output Pd12_a, 
    output Pd12_b,

    output Q1_3,
    output Q1_2,
    output Q1_1,
    output Q2_3,
    output Q2_1,
    output Q3_3,
    output Q3_2,
    output Q3_1,
    output Pxl_done_i,

    //one hot encode (active high) 
    output OTA_out_c,
    output SH_out_c,
    output CMP_out_c,
    output OTA_sh_c,
    output Vref_cmp_c,

    //Vref selector (default = fixed)
    output Vref_sel_c


);

    wire clk;
    wire rst;


    //---------RLBP control register
    reg [12:0] control_reg_rlbp_fsm;

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

    wire wire_en;
    wire wire_ce_d1;
    wire wire_ce_d2;
    wire wire_ce_d3;
    wire wire_data_in;
    wire [1:0] wire_data_sel; 
    wire [3:0] wire_d;
    wire wire_rst;
    wire [11:0] wire_q;
    wire wire_p2s_en;   
    wire wire_vd1;
    wire wire_vd2;
    wire wire_sw1;
    wire wire_sw2;
    wire wire_sh; 
    wire wire_sh_cmp; 
    wire wire_sh_reset;
    wire wire_counter_reset_out;
    wire wire_counter_reset; 
    wire wire_start;
    wire wire_ext_clk; 
    wire wire_wb_clk_macro; 
    wire wire_sel_clk; 
    wire wire_clk_out; 
    wire wire_ext_reset; 
    wire wire_wb_reset; 
    wire wire_sel_reset;
    wire wire_reset_out; 
    wire wire_ext_start; 
    wire wire_wb_start; 
    wire wire_sel_start; 
    wire wire_start_out; 
    wire wire_ext_clk_sync; 
    wire wire_wb_reset_sync; 
    wire wire_ext_reset_sync; 
    wire wire_wb_start_sync;
    wire wire_ext_start_sync; 
    wire wire_ext_clk_temp; 
    wire wire_wb_reset_temp;
    wire wire_ext_reset_temp; 
    wire wire_wb_start_temp;
    wire wire_ext_start_temp;

    //to LA
    wire pd1_a, pd1_b;
    wire pd2_a, pd2_b;
    wire pd3_a, pd3_b;
    wire pd4_a, pd4_b;
    wire pd5_a, pd5_b;
    wire pd6_a, pd6_b;
    wire pd7_a, pd7_b;
    wire pd8_a, pd8_b;
    wire pd9_a, pd9_b;
    wire pd10_a, pd10_b;
    wire pd11_a, pd11_b;
    wire pd12_a, pd12_b;


    //to control TGates (one hot encode, ACTIVE HIGH)
    wire ota_out_c;
    wire sh_out_c;
    wire cmp_out_c;
    wire ota_sh_c;
    wire vref_cmp_c;   
    //############## end on hot

    wire vref_sel_c;    // DEFAULT vref = fixed


    //registers (WB interface)
    reg [11:0] time_up_counter_reset_out;
    reg [11:0] time_down_counter_reset_out; 
    reg [11:0] time_up_vd1;
    reg [11:0] time_down_vd1; 
    reg [11:0] time_up_vd2; 
    reg [11:0] time_down_vd2;
    reg [11:0] time_up_sh_reset; 
    reg [11:0] time_down_sh_reset; 
    reg [11:0] time_up_sw1;
    reg [11:0] time_down_sw1; 
    reg [11:0] time_up_sw2; 
    reg [11:0] time_down_sw2;
    reg [11:0] time_up_sh; 
    reg [11:0] time_down_sh; 
    reg [11:0] time_up_sh_cmp; 
    reg [11:0] time_down_sh_cmp; 
    reg [11:0] reg_count;  //Counter
    reg [11:0] reg_q;



    //------ REGS ADDRs table (WSB)
    localparam TIME_UP_1 = 0;           //1
    localparam TIME_DOWN_1 = 4;         //2
    localparam TIME_UP_2 = 8;           //3
    localparam TIME_DOWN_2 = 12;        //...
    localparam TIME_UP_3 = 16;
    localparam TIME_DOWN_3 = 20;
    localparam TIME_UP_4 = 24;
    localparam TIME_DOWN_4 = 28;
    localparam TIME_UP_5 = 32;
    localparam TIME_DOWN_5 = 36;
    localparam TIME_UP_6 = 40;
    localparam TIME_DOWN_6 = 44;
    localparam TIME_UP_7 = 48;
    localparam TIME_DOWN_7 = 52;
    localparam COUNT_UP = 56;
    localparam COUNT_DOWN = 60;
    localparam COUNT_VALUE = 64;
    localparam Q = 68;



    //------ RLBP wires interconnection to Caravel LA

    //in and outs are relative to the macros
    //https://github.com/efabless/caravel_user_project/blob/main/verilog/dv/README.md

    //[31:0]
    //reg_la0_oenb = reg_la0_iena = 0xFF000000;    // [31:0]  OUTPUTS (00, 24bits)  INPUTS(FF, last 8bits)

    assign pd1_a = la_data_in[0];                  //out  
    assign pd1_b = la_data_in[1];                  //out  
    assign pd2_a = la_data_in[2];                  //out  
    assign pd2_b = la_data_in[3];                  //out   0 
    assign pd3_a = la_data_in[4];                  //out  
    assign pd3_b = la_data_in[5];                  //out  
    assign pd4_a = la_data_in[6];                  //out  
    assign pd4_b = la_data_in[7];                  //out   0  
    assign pd5_a = la_data_in[8];                  //out  
    assign pd5_b = la_data_in[9];                  //out
    assign pd6_a = la_data_in[10];                 //out  
    assign pd6_b = la_data_in[11];                 //out   0 
    assign pd7_a = la_data_in[12];                 //out  
    assign pd7_b = la_data_in[13];                 //out  
    assign pd8_a = la_data_in[14];                 //out  
    assign pd8_b = la_data_in[15];                 //out   0 
    assign pd9_a = la_data_in[16];                 //out
    assign pd9_b = la_data_in[17];                 //out
    assign pd10_a = la_data_in[18];                //out
    assign pd10_b = la_data_in[19];                //out   0
    assign pd11_a = la_data_in[20];                //out
    assign pd11_b = la_data_in[21];                //out  
    assign pd12_a = la_data_in[22];                //out  
    assign pd12_b = la_data_in[23];                //out   0  

    assign ota_out_c = la_data_in[24];             //out     
    assign sh_out_c = la_data_in[25];              //out     
    assign cmp_out_c = la_data_in[26];             //out     
    assign ota_sh_c = la_data_in[27];              //out  0    
    assign vref_cmp_c = la_data_in[28];            //out     
    assign vref_sel_c = la_data_in[29];            //out  
                                                           //0   



    assign wire_q = reg_q;  //q to reg



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



    // #####    Module specific ports interconections   #####

    assign ext_clk = wire_ext_clk;
    assign ext_start = wire_ext_start;
    assign ext_reset = wire_ext_reset;

    assign clk_o = wire_clk_out;  
    assign rst_o = wire_reset_out;
    assign done_o = wire_rlbp_done;
    assign start_o = wire_start_out;
    assign data_o = wire_s_data_out;
    //assign CMP_tmr  #####
    assign counter_rst = wire_counter_reset;
    assign Vd1 = wire_vd1;
    assign Vd2 = wire_vd2;
    assign Sw1 = wire_sw1;
    assign Sw2 = wire_sw2;
    assign Sh = wire_sh;
    assign Sh_cmp = wire_sh_cmp;
    assign Sh_rst = wire_sh_reset;

    assign Q1_3 = wire_q1_3;
    assign Q1_2 = wire_q1_2;
    assign Q1_1 = wire_q1_1;
    assign Q2_3 = wire_q2_3;
    assign Q2_1 = wire_q2_1;
    assign Q3_3 = wire_q3_3;
    assign Q3_2 = wire_q3_2;
    assign Q3_1 = wire_q3_1;
    assign Pxl_done_i = wire_pxl_done_i;


    assign Pd1_a = pd1_a;
    assign Pd1_b = pd1_b;
    assign Pd2_a = pd2_a;
    assign Pd2_b = pd2_b;
    assign Pd3_a = pd3_a;
    assign Pd3_b = pd3_b;
    assign Pd4_a = pd4_a;
    assign Pd4_b = pd4_b;
    assign Pd5_a = pd5_a;
    assign Pd5_b = pd5_b;
    assign Pd6_a = pd6_a;
    assign Pd6_b = pd6_b;
    assign Pd7_a = pd7_a; 
    assign Pd7_b = pd7_b;
    assign Pd8_a = pd8_a;
    assign Pd8_b = pd8_b;
    assign Pd9_a = pd9_a; 
    assign Pd9_b = pd9_b;
    assign Pd10_a = pd10_a;
    assign Pd10_b = pd10_b;
    assign Pd11_a = pd11_a;
    assign Pd11_b = pd11_b;
    assign Pd12_a = pd12_a;
    assign Pd12_b = pd12_b;

    
    //one hot encode (active high) 
    assign OTA_out_c = ota_out_c;
    assign SH_out_c = sh_out_c;
    assign CMP_out_c = cmp_out_c;
    assign OTA_sh_c = ota_sh_c;
    assign Vref_cmp_c = vref_cmp_c;

    //Vref selector (default = fixed)
    assign Vref_sel_c = vref_sel_c;


    

always@(posedge clk) begin
		if(rst) begin

            control_reg_rlbp_fsm <= 0;
            rdata <= 0; 
            wbs_done <= 0;

            time_up_vd1 <= 0;
            time_down_vd1 <= 0; 
            time_up_vd2 <= 0; 
            time_down_vd2 <= 0;
            time_up_sw1 <= 0;
            time_down_sw1 <= 0; 
            time_up_sw2 <= 0;
            time_down_sw2 <= 0;
            time_up_sh <= 0;
            time_down_sh <= 0;
            time_up_sh_cmp <= 0; 
            time_down_sh_cmp <= 0; 
            time_up_sh_reset <= 0; 
            time_down_sh_reset <= 0;
            time_up_counter_reset_out <= 0;
            time_down_counter_reset_out <= 0; 
            reg_count <= 0;  //Counter
            reg_q <= 0;

		end

    	else begin
			wbs_done <= 0;

            //WB SLAVE INTERFACE
			if (valid && addr_valid) begin  
                case(wbs_adr_i[7:0])  

                    
                    TIME_UP_1: begin
                        rdata <= time_up_vd1;
                        if(wstrb[0])
                            time_up_vd1 <= wdata[11:0];
                    end

                    TIME_DOWN_1: begin
                        rdata <= time_down_vd1;
                        if(wstrb[0])
                            time_down_vd1 <= wdata[11:0];
                    end       

                    TIME_UP_2: begin
                        rdata <= time_up_vd2;
                        if(wstrb[0])
                            time_up_vd2 <= wdata[11:0];
                    end

                    TIME_DOWN_2:  begin
                        rdata <= time_down_vd2;
                        if(wstrb[0])
                            time_down_vd2 <= wdata[11:0];
                    end

                    TIME_UP_3: begin
                        rdata <= time_up_sw1;
                        if(wstrb[0])
                            time_up_sw1 <= wdata[11:0];
                    end

                    TIME_DOWN_3: begin
                        rdata <= time_down_sw1;
                        if(wstrb[0])
                            time_down_sw1 <= wdata[11:0];  
                    end

                    TIME_UP_4: begin
                        rdata <= time_up_sw2;
                        if(wstrb[0])
                            time_up_sw2 <= wdata[11:0];  
                    end

                    TIME_DOWN_4:  begin
                        rdata <= time_down_sw2;
                        if(wstrb[0])	
                            time_down_sw2 <= wdata[11:0];
                    end

                    TIME_UP_5: begin
                        rdata <= time_up_sh;
                        if(wstrb[0])
                            time_up_sh <= wdata[11:0];  
                    end

                    TIME_DOWN_5:  begin	
                        rdata <= time_down_sh;
                        if(wstrb[0])
                            time_down_sh <= wdata[11:0];
                    end

                    TIME_UP_6: begin
                        rdata <= time_up_sh_cmp;
                        if(wstrb[0])
                            time_up_sh_cmp <= wdata[11:0];  
                    end

                    TIME_DOWN_6:  begin
                        rdata <= time_down_sh_cmp;
                        if(wstrb[0])	
                            time_down_sh_cmp <= wdata[11:0];
                    end

                    TIME_UP_7: begin
                        rdata <= time_up_sh_reset;
                        if(wstrb[0])
                            time_up_sh_reset <= wdata[11:0];  
                    end

                    TIME_DOWN_7:  begin
                        rdata <= time_down_sh_reset;
                        if(wstrb[0])	
                            time_down_sh_reset <= wdata[11:0];
                    end

                    COUNT_UP: begin
                        rdata <= time_up_counter_reset_out;
                        if(wstrb[0])
                            time_up_counter_reset_out <= wdata[11:0];  
                    end

                    COUNT_DOWN: begin
                        rdata <= time_down_counter_reset_out;
                        if(wstrb[0])
                            time_down_counter_reset_out <= wdata[11:0];  
                    end

                    COUNT_VALUE: begin
                        rdata <= reg_count;
                        if(wstrb[0])
                            reg_count <= wdata[11:0];  
                    end

                    Q:  begin
                        rdata <= reg_q;
                        if(wstrb[0])	
                            reg_q <= wdata[11:0];
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
    .ce_d1(wire_ce_d1),
    .ce_d2(wire_ce_d2),
    .ce_d3(wire_ce_d3),
    .reset(rst),
    .reset_fsm(wire_reset_fsm),
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
    .ready(wire_ready), //P2S conversion ready
    //fsm-counter-triggers

    .count(reg_count),
    .q(wire_q),
    .start(wire_start), 
    .p2s_en(wire_p2s_en),   
    .time_up_vd1(time_up_vd1), 
    .time_down_vd1(time_down_vd1), 
    .vd1(wire_vd1), 
    .time_up_vd2(time_up_vd2), 
    .time_down_vd2(time_down_vd2), 
    .vd2(wire_vd2), 
    .time_up_sw1(time_up_sw1), 
    .time_down_sw1(time_down_sw1), 
    .sw1(wire_sw1), 
    .time_up_sw2(time_up_sw2),         
    .time_down_sw2(time_down_sw2), 
    .sw2(wire_sw2), 
    .time_up_sh(time_up_sh), 
    .time_down_sh(time_down_sh), 
    .sh(wire_sh), 
    .time_up_sh_cmp(time_up_sh_cmp), 
    .time_down_sh_cmp(time_down_sh_cmp), 
    .sh_cmp(wire_sh_cmp), 
    .time_up_sh_reset(time_up_sh_reset), 
    .time_down_sh_reset(time_down_sh_reset), 
    .sh_reset(wire_sh_reset), 
    .time_up_counter_reset_out(time_up_counter_reset_out), 
    .time_down_counter_reset_out(time_down_counter_reset_out), 
    .counter_reset_out(wire_counter_reset_out), 
    .counter_reset(wire_counter_reset), 
    .ext_clk(wire_ext_clk), 
    .wb_clk_macro(wire_wb_clk_macro), 
    .sel_clk(wire_sel_clk), 
    .clk_out(wire_clk_out), 
    .ext_reset(wire_ext_reset), 
    .wb_reset(wire_wb_reset), 
    .sel_reset(wire_sel_reset), 
    .reset_out(wire_reset_out), 
    .ext_start(wire_ext_start), 
    .wb_start(wire_wb_start), 
    .sel_start(wire_sel_start), 
    .start_out(wire_start_out), 
    .ext_clk_sync(wire_ext_clk_sync), 
    .wb_reset_sync(wire_wb_reset_sync), 
    .ext_reset_sync(wire_ext_reset_sync), 
    .wb_start_sync(wire_wb_start_sync), 
    .ext_start_sync(wire_ext_start_sync), 
    .ext_clk_temp(wire_ext_clk_temp), 
    .wb_reset_temp(wire_wb_reset_temp), 
    .ext_reset_temp(wire_ext_reset_temp), 
    .wb_start_temp(wire_wb_start_temp), 
    .ext_start_temp(wire_ext_start_temp)
);




endmodule

`default_nettype wire
