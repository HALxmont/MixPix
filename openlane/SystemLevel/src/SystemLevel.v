`default_nettype none

module SystemLevel(
`ifdef USE_POWER_PINS
    input   VDD,
    input   VSS,
    input   Ibias,
`endif
      
    input   OTA_out_c,    
    input   SH_out_c,
    input   Vref_cmp_c,
    input   OTA_sh_c,
    input   CMP_out_c,
    input   Vref_sel_c,
    input   Vd1,  
    input   Vd2,
    input   sw1,
    input   sw2,
    input   sh,
    input   sh_cmp,
    input   sh_rst,

    input   pd1_a,
    input   pd1_b,
    input   pd2_a,
    input   pd2_b,
    input   pd3_a,
    input   pd3_b,
    input   pd4_a,
    input   pd4_b,
    input   pd5_a,
    input   pd5_b,
    input   pd6_a,
    input   pd6_b,
    input   pd7_a,
    input   pd7_b,
    input   pd8_a,
    input   pd8_b,
    input   pd9_a,
    input   pd9_b,
    input   pd10_a,
    input   pd10_b,
    input   pd11_a,
    input   pd11_b,
    input   pd12_a,
    input   pd12_b,

    output  PD1,
    output  PD2,
    output  PD3,
    output  PD4,
    output  PD5,
    output  PD6,
    output  PD7,
    output  PD8,
    output  PD9,
    output  PD10,
    output  PD11,
    output  PD12,
    output  CMP,
    output  Aout

);



endmodule
`default_nettype wire
