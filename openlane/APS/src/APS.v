`default_nettype none


// Input RST - al  digital input,   IP   - analog input,
// 6:47
// VDD y VSS cualquiera de los dos que usamos
// 6:47
// output OUT - analoga

module APS(
    
`ifdef USE_POWER_PINS
    input   VDD,
    input   VSS,
`endif
    
    input  RST,
    input  IP,
    output OUT

);




endmodule
`default_nettype wire

