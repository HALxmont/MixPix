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

// ------------------- Design Specific Ports ----------------- //

    input CMP,
    output Vd1,
    output Vd2,
    output Sw1,
    output Sw2,
    output Sh,          
    output Sh_cmp,
    output Sh_rst,
    output Pd1_a, Pd1_b,
    output Pd2_a, Pd2_b,
    output Pd3_a, Pd3_b,
    output Pd4_a, Pd4_b,
    output Pd5_a, Pd5_b,
    output Pd6_a, Pd6_b,
    output Pd7_a, Pd7_b,
    output Pd8_a, Pd8_b,
    output Pd9_a, Pd9_b,
    output Pd10_a, Pd10_b,
    output Pd11_a, Pd11_b,
    output Pd12_a, Pd12_b,
    output CLR,

    //one hot encode (active high) 
    output OTA_out_c,
    output SH_out_c,
    output CMP_out_c,
    output OTA_sh_c,
    output Vref_cmp_c,

    //Vref selector (default = fixed)
    output Vref_sel_c


);




// #-------------  RLBP wires interconnection to Caravel LA -----------#

    //in and outs are relative to the macros
    //https://github.com/efabless/caravel_user_project/blob/main/verilog/dv/README.md

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
    wire wire_sel_reset;
    wire wire_wb_start; 
    wire wire_sel_start; 
    wire wire_sel_clk;
    wire vref_sel_c;    

    assign pd1_a = la_data_in[0];                    
    assign pd1_b = la_data_in[1];                     
    assign pd2_a = la_data_in[2];                     
    assign pd2_b = la_data_in[3];                    
    assign pd3_a = la_data_in[4];                     
    assign pd3_b = la_data_in[5];                     
    assign pd4_a = la_data_in[6];                     
    assign pd4_b = la_data_in[7];                     
    assign pd5_a = la_data_in[8];                     
    assign pd5_b = la_data_in[9];                   
    assign pd6_a = la_data_in[10];                    
    assign pd6_b = la_data_in[11];                   
    assign pd7_a = la_data_in[12];                    
    assign pd7_b = la_data_in[13];                    
    assign pd8_a = la_data_in[14];                    
    assign pd8_b = la_data_in[15];                   
    assign pd9_a = la_data_in[16];                  
    assign pd9_b = la_data_in[17];                  
    assign pd10_a = la_data_in[18];                 
    assign pd10_b = la_data_in[19];                 
    assign pd11_a = la_data_in[20];                 
    assign pd11_b = la_data_in[21];                   
    assign pd12_a = la_data_in[22];                   
    assign pd12_b = la_data_in[23];                   

    assign ota_out_c = la_data_in[24];                   
    assign sh_out_c = la_data_in[25];                    
    assign cmp_out_c = la_data_in[26];                   
    assign ota_sh_c = la_data_in[27];                   
    assign vref_cmp_c = la_data_in[28];                  
    assign vref_sel_c = la_data_in[29];               

    assign wire_sel_start = la_data_in[30];
    assign wire_sel_reset = la_data_in[31];  
    assign wire_sel_clk = la_data_in[32];                                                  //0   
    assign wire_wb_start = la_data_in[33]; 


    //assign rst = la_data_in[34];



// ---------------------------- WB interface ---------------------------//
 
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

    //registers (WB slave interface)
    reg [11:0] time_counter_reset; 
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
    reg [11:0] time_cmp;

    reg [7:0] sr;



    // WB REGS ADDRs values 
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
    localparam COUNT_RST = 56;
    localparam TIME_CMP = 60;
    localparam SR = 64;



// ------------------- assigns to IOs pins ------------------------------- //
    wire wire_ext_clk; 
    wire wire_ext_start; 
    wire wire_ext_reset; 

    assign wire_ext_clk = io_in[15];
    assign wire_ext_start = io_in[16];
    assign wire_ext_reset = io_in[17];
    
    assign io_out[18] = CMP; 
    assign io_out[19] = start;
    assign io_out[20] = rst;
    assign io_out[21] = clk;
    assign io_out[22] = cmp_valid;   //data valid pulse

    assign io_out[23] = sr[0];
    assign io_out[24] = sr[1];
    assign io_out[25] = sr[2];
    assign io_out[26] = sr[3];
    assign io_out[27] = sr[4];
    assign io_out[28] = sr[5];
    assign io_out[29] = sr[6];
    assign io_out[30] = sr[7];
    assign io_out[31] = clr;

     
// ---------------- Module specific ports interconections ------------------//

    wire wire_vd1;
    wire wire_vd2;
    wire wire_sw1;
    wire wire_sw2;
    wire wire_sh; 
    wire wire_sh_cmp; 
    wire wire_sh_reset; 

   //to control TGates (one hot encode, ACTIVE HIGH)
    wire ota_out_c;  
    wire sh_out_c;
    wire cmp_out_c;
    wire ota_sh_c;
    wire vref_cmp_c; 

    //to sate machines
    assign Vd1 = wire_vd1;
    assign Vd2 = wire_vd2;
    assign Sw1 = wire_sw1;
    assign Sw2 = wire_sw2;
    assign Sh = wire_sh;
    assign Sh_cmp = wire_sh_cmp;
    assign Sh_rst = wire_sh_reset;

    //transistors siganls
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

    //clear out
    assign CLR = clr; 

    //one hot encode (active high) 
    assign OTA_out_c = ota_out_c;   
    assign SH_out_c = sh_out_c;
    assign CMP_out_c = cmp_out_c;
    assign OTA_sh_c = ota_sh_c;
    assign Vref_cmp_c = vref_cmp_c;

    //Vref selector (default = fixed)
    assign Vref_sel_c = vref_sel_c; 



//-------------------- Multiplexers for Clock, Reset and Enable ------------------- //
    wire [11:0] cnt;
    wire start;
    wire clk;
    wire rst;
	assign clk = wire_sel_clk ? ext_clk_sync : wb_clk_i;  //wire_ext_clk no deberia ser wire_ext_clk_sync???
	assign rst = wire_sel_reset ? ext_reset_sync : wb_rst_i;
	assign start = wire_sel_start ? ext_start_sync : wire_wb_start;



// -------------------- Syncronizers for Clock, Reset and Enable Signals ----------------//


reg ext_clk_sync , ext_reset_sync , ext_start_sync;
reg ext_clk_temp, ext_reset_temp, ext_start_temp;


	always @(posedge wb_clk_i)
	begin 
        if (wb_rst_i) begin
            ext_clk_temp <= 0;
            ext_clk_sync <= 0;
        end
        else begin
            ext_clk_temp <= wire_ext_clk;
            ext_clk_sync <= ext_clk_temp;
        end
	end

	always @(posedge wb_clk_i)
	begin

        if (wb_rst_i) begin
            ext_reset_temp <= 0;
            ext_reset_sync <= 0;
        end
        else begin
            ext_reset_temp <= wire_ext_reset;
            ext_reset_sync <= ext_reset_temp;
        end
	end	
	
	always @(posedge wb_clk_i)
	begin

        if (wb_rst_i) begin
            ext_start_temp <= 0;
            ext_start_sync <= 0;
        end
        else begin
            ext_start_temp <= wire_ext_start;
            ext_start_sync <= ext_start_temp;
        end

	end


// ------------------------ Triggers state machines ----------------------------- //

    counter counter0(clk, rst, start, clr, cnt);
    sh_cmp_fsm sh_cmp_fsm0(clk, rst, cnt, time_up_sh_cmp, time_down_sh_cmp, wire_sh_cmp);
    sh_fsm sh_fsm0(clk, rst, cnt, time_up_sh, time_down_sh, wire_sh);

    vd1_fsm vd1_fsm0(clk, rst, cnt, time_up_vd1, time_down_vd1, wire_vd1);
    vd2_fsm vd2_fsm0(clk, rst, cnt, time_up_vd2, time_down_vd2, wire_vd2);
    sw1_fsm sw1_fsm0(clk, rst, cnt, time_up_sw1, time_down_sw1, wire_sw1);
    sw2_fsm sw2_fsm0(clk, rst, cnt, time_up_sw2, time_down_sw2, wire_sw2);
    sh_reset_fsm sh_reset_fsm0(clk, rst, cnt, time_up_sh_reset, time_down_sh_reset, wire_sh_reset);

    //sampling 
    wire cmp_valid;
    wire clr;

    assign clr = (cnt == time_counter_reset) ? 1 : 0;
    assign cmp_valid = (cnt == time_cmp) ? 1 : 0;
    
    //RLBP OUTS
    
    always @(posedge clk) begin
        if (rst)
            sr <= 0;
        else begin
            if (cmp_valid)
                sr <= {sr[6:0], CMP};    
        end
    end



// --------------------- WB slave interface -------------------------------------- //  

always@(posedge clk) begin
		if(rst) begin

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
            time_counter_reset <= 0; 
            reg_count <= 0;  //Counter
            time_cmp <= 0;
            sr <= 0;

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


                    COUNT_RST: begin
                        rdata <= time_counter_reset;
                        if(wstrb[0])
                            time_counter_reset <= wdata[11:0];  
                    end

                    TIME_CMP:  begin
                        rdata <= time_cmp;
                        if(wstrb[0])	
                            time_cmp <= wdata[11:0];
                    end

                    SR: begin
                        rdata <= sr;
                        if(wstrb[0])
                            sr <= wdata[7:0];
                    end

                    default: ;

				endcase
                wbs_done <= 1;
            end	
        end
end 

endmodule


`default_nettype wire
