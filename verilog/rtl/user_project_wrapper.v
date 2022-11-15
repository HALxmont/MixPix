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
//`include "/home/mxmont/Documents/Universidad/IC-UBB/MixPix/CARAVEL_WRAPPER/MixPix/openlane/pixel/src/pixel_macro.v"
`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_project_wrapper
 *
 * This wrapper enumerates all of the pins available to the
 * user for the user project.
 *
 * An example user project is provided in this wrapper.  The
 * example should be removed and replaced with the actual
 * user project.
 *
 *-------------------------------------------------------------
 */

module user_project_wrapper #(
    parameter BITS = 32
) (
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

    // Analog (direct connection to GPIO pad---use with caution)
    // Note that analog I/O is not available on the 7 lowest-numbered
    // GPIO pads, and so the analog_io indexing is offset from the
    // GPIO indexing by 7 (also upper 2 GPIOs do not have analog_io).
    inout [`MPRJ_IO_PADS-10:0] analog_io,

    // Independent clock (on independent integer divider)
    input   user_clock2,

    // User maskable interrupt signals
    output [2:0] user_irq
);



// -------------- wires to connect rlbp and system level

wire vd1;
wire vd2;
wire sw1;
wire sw2;
wire sh;
wire sh_cmp;
wire sh_rst;

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

wire pd1;
wire pd2;
wire pd3;
wire pd4;
wire pd5;
wire pd6;
wire pd7;
wire pd8;
wire pd9;
wire pd10;
wire pd11;
wire pd12;
wire cmp;

//to control TGates (one hot encode, ACTIVE HIGH)
wire ota_out_c;
wire sh_out_c;
wire cmp_out_c;
wire ota_sh_c;
wire vref_cmp_c;   
//############## end on hot

wire vref_sel_c;    // DEFAULT vref = fixed

//-----------------------------------------------------------------------



rlbp_macro rlbp_macro0 (

`ifdef USE_POWER_PINS
	.vccd1(vccd1),	// User area 1 1.8V power
	.vssd1(vssd1),	// User area 1 digital ground
`endif

    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),

    // MGMT SoC Wishbone Slave

    .wbs_cyc_i(wbs_cyc_i),
    .wbs_stb_i(wbs_stb_i),
    .wbs_we_i(wbs_we_i),
    .wbs_sel_i(wbs_sel_i),
    .wbs_adr_i(wbs_adr_i),
    .wbs_dat_i(wbs_dat_i),
    .wbs_ack_o(wbs_ack_o),
    .wbs_dat_o(wbs_dat_o),

    // Logic Analyzer

    .la_data_in(la_data_in),
    .la_data_out(la_data_out),
    .la_oenb (la_oenb),

    // IO Pads

    .io_in (io_in),
    .io_out(io_out),
    .io_oeb(io_oeb),

    // IRQ
    
    .irq(user_irq),
    .Vd1(vd1),
    .Vd2(vd2),
    .Sw1(sw1),
    .Sw2(sw2),
    .Sh(sh),
    .Sh_cmp(sh_cmp),
    .Sh_rst(sh_rst),
    
    .Pd1_a(pd1_a), 
    .Pd1_b(pd1_b),
    .Pd2_a(pd2_a), 
    .Pd2_b(pd2_b),
    .Pd3_a(pd3_a), 
    .Pd3_b(pd3_b),
    .Pd4_a(pd4_a), 
    .Pd4_b(pd4_b),
    .Pd5_a(pd5_a), 
    .Pd5_b(pd5_b),
    .Pd6_a(pd6_a), 
    .Pd6_b(pd6_b),
    .Pd7_a(pd7_a), 
    .Pd7_b(pd7_b),
    .Pd8_a(pd8_a), 
    .Pd8_b(pd8_b),
    .Pd9_a(pd9_a), 
    .Pd9_b(pd9_b),
    .Pd10_a(pd10_a), 
    .Pd10_b(pd10_b),
    .Pd11_a(pd11_a), 
    .Pd11_b(pd11_b),
    .Pd12_a(pd12_a), 
    .Pd12_b(pd12_b),

    .OTA_out_c(ota_out_c),
    .SH_out_c(sh_out_c),
    .CMP_out_c(cmp_out_c),
    .OTA_sh_c(ota_sh_c),
    .Vref_cmp_c(vref_cmp_c),
    .Vref_sel_c(vref_sel_c),
    .CMP(cmp)

);




SystemLevel sl_macro0(

`ifdef USE_POWER_PINS
    .VDD(vdda1),
    .VSS(vssa1),
    .Ibias(vdda2),
`endif

    
    .OTA_out_c(ota_out_c),
    .SH_out_c(sh_out_c),
    .Vref_cmp_c(vref_cmp_c),
    .OTA_sh_c(ota_sh_c),
    .CMP_out_c(cmp_out_c),
    .Vref_sel_c(vref_sel_c),
    .Vd1(vd1),
    .Vd2(vd2),
    .sw1(sw1),
    .sw2(sw2),
    .sh(sh),
    .sh_cmp(sh_cmp),
    .sh_rst(sh_rst),
    .pd1_a(pd1_a),
    .pd1_b(pd1_b),
    .pd2_a(pd2_a),
    .pd2_b(pd2_b),
    .pd3_a(pd3_a),
    .pd3_b(pd3_b),
    .pd4_a(pd4_a),
    .pd4_b(pd4_b),
    .pd5_a(pd5_a),
    .pd5_b(pd5_b),
    .pd6_a(pd6_a),
    .pd6_b(pd6_b),
    .pd7_a(pd7_a),
    .pd7_b(pd7_b),
    .pd8_a(pd8_a),
    .pd8_b(pd8_b),
    .pd9_a(pd9_a),
    .pd9_b(pd9_b),
    .pd10_a(pd10_a),
    .pd10_b(pd10_b),
    .pd11_a(pd11_a),
    .pd11_b(pd11_b),
    .pd12_a(pd12_a),
    .pd12_b(pd12_b),
    .PD1(pd1),
    .PD2(pd2),
    .PD3(pd3),
    .PD4(pd4),
    .PD5(pd5),
    .PD6(pd6),
    .PD7(pd7),
    .PD8(pd8),
    .PD9(pd9),
    .PD10(pd10),
    .PD11(pd11),
    .PD12(pd12),
    .CMP(cmp),
    .Aout(analog_io[26])
);



PD_M1_M2 PD_M1_M2_macro0 (

`ifdef USE_POWER_PINS
    .VDD(vdda2),   
    .VSS(vssa1),
`endif

    .PD1(pd1),
    .PD2(pd2),
    .PD3(pd3),
    .PD4(pd4),
    .PD5(pd5),
    .PD6(pd6),
    .PD7(pd7),
    .PD8(pd8),
    .PD9(pd9),
    .PD10(pd10),
    .PD11(pd11),
    .PD12(pd12)

);


// APS APS_macro0 (

// `ifdef USE_POWER_PINS
//     .VDD(vdda2),   
//     .VSS(vssa1),
// `endif

// .RST(io_in[7]),
// .IP(analog_io[0]),
// .OUT(analog_io[1])

// );



// muler muler_macro0 (

// `ifdef USE_POWER_PINS
//     .VDD(vccd1),   
//     .VSS(vssd1),
// `endif

// .M(io_in[4]),
// .P(io_in[5]),
// .C(io_in[6]),
// .OUT(io_out[5])

// );


endmodule	// user_project_wrapper

`default_nettype wire
