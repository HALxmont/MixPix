`default_nettype none

module res(

`ifdef USE_POWER_PINS
    input   VDD,
    input   VSS,
`endif
    
    input  in1,
    input  in2,
    output out1,
    output out2

);

endmodule
`default_nettype wire

