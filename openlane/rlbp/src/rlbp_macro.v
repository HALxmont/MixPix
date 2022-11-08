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

    output serial_data_rlbp_out,

    output rst,
    output out_1,
    output out_2, 
    output out_3, 
    output out_4, 
    output out_5,
    output out_7

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
    wire wire_gpio_start;
    wire wire_logic_analyzer_start;
    wire wire_data_in;
    wire [1:0] wire_data_sel; 
    wire [3:0] wire_d;


    wire wire_reset_c;
    wire wire_en_c;
    wire wire_rst;
    wire wire_out_1; 
    wire wire_out_2; 
    wire wire_out_3; 
    wire wire_out_4; 
    wire wire_out_5;
    wire wire_out_7;

    //registers
    reg [10:0] reg_time_up_1;
    reg [10:0] reg_time_down_1;
    reg [10:0] reg_time_up_2;
    reg [10:0] reg_time_down_2; 
    reg [10:0] reg_time_up_3; 
    reg [10:0] reg_time_down_3; 
    reg [10:0] reg_time_up_4; 
    reg [10:0] reg_time_down_4;
    reg [10:0] reg_time_up_5; 
    reg [10:0] reg_time_down_5;
    reg [10:0] reg_time_up_7;
    reg [10:0] reg_time_down_7;
    reg [11:0] reg_count;
    reg [11:0] reg_q;

    //------ REGS ADDRs table (WSB)
    localparam TIME_UP_1 = 0;
    localparam TIME_DOWN_1 = 4;
    localparam TIME_UP_2 = 8;
    localparam TIME_DOWN_2 = 12;
    localparam TIME_UP_3 = 16;
    localparam TIME_DOWN_3 = 20;
    localparam TIME_UP_4 = 24;
    localparam TIME_DOWN_4 = 28;
    localparam TIME_UP_5 = 32;
    localparam TIME_DOWN_5 = 36;
    localparam TIME_UP_7 = 40;
    localparam TIME_DOWN_7 = 44;
    localparam COUNT = 48;
    localparam Q = 52;



    //------ RLBP wires interconnection to Caravel LA

    //in and outs are relative to the macros
    //https://github.com/efabless/caravel_user_project/blob/main/verilog/dv/README.md

    //[95:64]
    assign wire_reset_fsm = la_data_out[64];                //out
    assign wire_rlbp_done = la_data_out[65];                //out
    assign wire_q1_3 = la_data_out[66];                     //out
    assign wire_q1_2 = la_data_out[67];                     //out   0
    assign wire_q1_1 = la_data_out[68];                     //out
    assign wire_q2_3 = la_data_out[69];                     //out
    assign wire_q2_2 = la_data_out[70];                     //out
    assign wire_q2_1 = la_data_out[71];                     //out   0
    assign wire_q3_3 = la_data_out[72];                     //out
    assign wire_q3_2 = la_data_out[73];                     //out
    assign wire_q3_1 = la_data_out[74];                     //out
    assign wire_control_signals = la_data_out[78:75];       //out   00


    //pixel_macro [79:82] ...
    assign wire_ce_d1 = la_data_in[83];                    //in
    assign wire_ce_d2 = la_data_in[84];                    //in
    assign wire_ce_d3 = la_data_in[85];                    //in
    assign wire_gpio_start = la_data_in[86];               //in    F
    assign wire_logic_analyzer_start = la_data_in[87];     //in
    assign wire_data_in = la_data_in[88];                  //in
    assign wire_data_sel = la_data_in[90:89];              //in
    assign wire_en = la_data_in[91];                       //in    F
    assign wire_d = la_data_in[95:92];                     //in    F
                                                            // pixel 79:82 | rlbp 83:95 -> 0x-FFFF0000 


    //[127:96]
    assign wire_p_data_in = la_data_in[103:96];             //in    FF  ###test 
    assign wire_data_out = la_data_out[107:104];            //out   0
    assign wire_s_data_out = la_data_out[108];              //out
    assign wire_ready = la_data_out[109];                   //out

    assign wire_rst = la_data_out[110];                     //out
    assign wire_out_1 = la_data_out[111];                   //out   0
    assign wire_out_2 = la_data_out[112];                   //out
    assign wire_out_3 = la_data_out[113];                   //out
    assign wire_out_4 = la_data_out[114];                   //out
    assign wire_out_5 = la_data_out[115];                   //out   0
    assign wire_out_7 = la_data_out[116];                   //out   116,117,118,119 -> 0
    
    assign wire_reset_c = la_data_in[120];                   //in   F   
    assign wire_en_c = la_data_in[121];                      //in


    //outputs RLBP MACRO
    assign wire_rst = rst;
    assign wire_out_1 = out_1;
    assign wire_out_2 = out_2;
    assign wire_out_3 = out_3; 
    assign wire_out_4 = out_4; 
    assign wire_out_5 = out_5;
    assign wire_out_7 = out_7;



    //------ RLBP wires interconnection to RLBP control register
    // assign wire_p_data_in = control_reg_rlbp_fsm[7:0];
    


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
                // rdata <= {{19{1'b0}}, control_reg_rlbp_fsm};  //fill 32 bits

                // if(wstrb[0]) begin
                //     control_reg_rlbp_fsm <= wdata[12:0];
                // end
                case(wbs_adr_i[7:0])  

                    TIME_UP_1: begin
                        if(wstrb[0])
                            reg_time_up_1 <= wdata[10:0];
                    end

                    TIME_DOWN_1: begin
                        if(wstrb[0])
                            reg_down_up_1 <= wdata[10:0];
                    end       

                    TIME_UP_2: begin
                        if(wstrb[0])
                            reg_time_up_2 <= wdata[10:0];
                    end

                    TIME_DOWN_2:  begin
                        if(wstrb[0])
                            reg_time_down_2 <= wdata[10:0];
                    end

                    TIME_UP_3: begin
                        if(wstrb[0])
                            reg_time_up_3 <= wdata[10:0];
                    end

                    TIME_DOWN_3: begin
                        if(wstrb[0])
                            reg_time_down_3 <= wdata[10:0];  
                    end

                    TIME_UP_4: begin
                        if(wstrb[0])
                            reg_time_up_4 <= wdata[10:0];  
                    end

                    TIME_DOWN_4:  begin
                        if(wstrb[0])	
                            reg_time_down_4 <= wdata[10:0];
                    end

                    TIME_UP_5: begin
                        if(wstrb[0])
                            reg_time_up_5 <= wdata[10:0];  
                    end

                    TIME_DOWN_5:  begin	
                        if(wstrb[0])
                            reg_time_down_5 <= wdata[10:0];
                    end

                    TIME_UP_7: begin
                        if(wstrb[0])
                            reg_time_up_7 <= wdata[10:0];  
                    end

                    TIME_DOWN_7:  begin
                        if(wstrb[0])	
                            reg_time_down_7 <= wdata[10:0];
                    end

                    COUNT: begin
                        if(wstrb[0])
                            reg_count <= wdata[11:0];  
                    end

                    Q:  begin
                        if(wstrb[0])	
                            reg_q <= wdata[11:0];
                    end


                    default: ;

				endcase


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
    .ready(wire_ready), //P2S conversion ready
    //fsm-counter-triggers
    .reset_c(wire_reset_c),
    .en_c(wire_en_c),
    .time_up_1(reg_time_up_1), 
    .time_down_1(reg_time_down_1), 
    .time_up_2(reg_time_up_2), 
    .time_down_2(reg_time_down_2), 
    .time_up_3(reg_time_up_3), 
    .time_down_3(reg_time_down_3), 
    .time_up_4(reg_time_up_4), 
    .time_down_4(reg_time_down_4), 
    .time_up_5(reg_time_up_5), 
    .time_down_5(reg_time_down_5), 
    .time_up_7(reg_time_up_7), 
    .time_down_7(reg_time_down_7),
    .count(reg_count),
    .q(reg_q),
    .rst(wire_rst), 
    .out_1(wire_out_1), 
    .out_2(wire_out_2), 
    .out_3(wire_out_3), 
    .out_4(wire_out_4), 
    .out_5(wire_out_5), 
    .out_7(wire_out_7)
);




endmodule

`default_nettype wire
