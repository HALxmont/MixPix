//
// RLBP FSM
//
module rlbp_fsm (clk, reset, reset_fsm, gpio_start, ce_d1, ce_d2, ce_d3, logic_analyzer_start, control_signals, rlbp_done);
	input clk, reset, gpio_start, logic_analyzer_start;
	output reg reset_fsm, ce_d1, ce_d2, ce_d3, rlbp_done;
//	reg reset_fsm, rlbp_done;
	output reg [1:0] control_signals;
	reg [3:0] state_rlbp;
	reg [3:0] next_state_rlbp;
	
	parameter RESET_RLBP = 4'b0000; parameter S_REG_1_3 = 4'b0001; parameter S_REG_1_2 = 4'b0010; parameter S_REG_1_1 = 4'b0011; 
	parameter S_REG_2_3 = 4'b0100; parameter S_REG_2_2 = 4'b0101; parameter S_REG_2_1 = 4'b0110; 
	parameter S_REG_3_3 = 4'b0111; parameter S_REG_3_2 = 4'b1000; parameter S_REG_3_1 = 4'b1001; parameter WAIT = 4'b1010; 
	
	initial begin
		state_rlbp = 4'b0000;
		ce_d1 = 1'b0;
		ce_d2 = 1'b0;
		ce_d3 = 1'b0;
	end
	
	always @(posedge clk or posedge reset)
	begin
		if (reset) state_rlbp <= RESET_RLBP;
		else state_rlbp <= next_state_rlbp;
	end

	always @(state_rlbp or gpio_start or logic_analyzer_start)// or gpio_start or logic_analyzer_start) 
	begin
		case (state_rlbp)
			RESET_RLBP:	if (gpio_start==1'b0 && logic_analyzer_start==1'b0) begin
						next_state_rlbp = RESET_RLBP; end
					else if (gpio_start==1'b1 && logic_analyzer_start==1'b1) begin
						next_state_rlbp = RESET_RLBP; end
					else begin
		       			 next_state_rlbp = S_REG_1_3; end
			S_REG_1_3:	next_state_rlbp = S_REG_1_2;
			S_REG_1_2:	next_state_rlbp = S_REG_1_1;
			S_REG_1_1:	next_state_rlbp = S_REG_2_3;
			S_REG_2_3:	next_state_rlbp = S_REG_2_2;
			S_REG_2_2:	next_state_rlbp = S_REG_2_1;
			S_REG_2_1:	next_state_rlbp = S_REG_3_3;
			S_REG_3_3:	next_state_rlbp = S_REG_3_2;
			S_REG_3_2:	next_state_rlbp = S_REG_3_1;
			S_REG_3_1:	next_state_rlbp = WAIT;
/*
			S_REG_1_3:	if (shift_done) begin
						next_state_rlbp = S_REG_1_2; end
					else begin
						next_state_rlbp = S_REG_1_3; end
*/
			WAIT: 	if (gpio_start==1'b0 && logic_analyzer_start==1'b0) begin
						next_state_rlbp = RESET_RLBP; end
					else if (gpio_start==1'b1 && logic_analyzer_start==1'b1) begin
						next_state_rlbp = RESET_RLBP; end
					else begin
						next_state_rlbp = WAIT; end
			default: next_state_rlbp = RESET_RLBP;
		endcase
	end

	
	always @(state_rlbp)
	begin
		case (state_rlbp)
			RESET_RLBP: 	begin
					reset_fsm = 1'b1;
					control_signals = 2'b00;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					end
			S_REG_1_3:	begin
					reset_fsm = 1'b0;
					control_signals = 2'b01;
					ce_d1 = 1'b1;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					end
			S_REG_1_2:	begin
					reset_fsm = 1'b0;
					control_signals = 2'b01;
					ce_d1 = 1'b1;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					end
			S_REG_1_1:	begin
					reset_fsm = 1'b0;
					control_signals = 2'b01;
					ce_d1 = 1'b1;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					end
			S_REG_2_3:	begin
					reset_fsm = 1'b0;
					control_signals = 2'b10;
					ce_d1 = 1'b0;
					ce_d2 = 1'b1;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					end
			S_REG_2_2:	begin
					reset_fsm = 1'b0;
					control_signals = 2'b10;
					ce_d1 = 1'b0;
					ce_d2 = 1'b1;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					end
			S_REG_2_1:	begin
					reset_fsm = 1'b0;
					control_signals = 2'b10;
					ce_d1 = 1'b0;
					ce_d2 = 1'b1;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					end
			S_REG_3_3:	begin
					reset_fsm = 1'b0;
					control_signals = 2'b11;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b1;
					rlbp_done = 1'b0;
					end
			S_REG_3_2:	begin
					reset_fsm = 1'b0;
					control_signals = 2'b11;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b1;
					rlbp_done = 1'b0;
					end		
			S_REG_3_1:	begin
					reset_fsm = 1'b0;
					control_signals = 2'b11;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b1;
					rlbp_done = 1'b1;
					end
			WAIT:		begin
					reset_fsm = 1'b0;
					control_signals = 2'b00;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b1;
					end
		endcase
	end

endmodule

//3 Shift Registers 
module shift_register (clk, ce_d1, ce_d2, ce_d3, reset, d, q1_3, q1_2, q1_1, q2_3, q2_2, q2_1, q3_3, q3_2, q3_1);
	input clk, ce_d1, ce_d2, ce_d3, reset;
	input [3:0] d;
	output reg q1_3, q1_2, q1_1, q2_3, q2_2, q2_1, q3_3, q3_2, q3_1;
	
initial begin
	q1_3=1'b0; q1_2=1'b0; q1_1=1'b0; q2_3=1'b0; q2_2=1'b0; q2_1=1'b0; q3_3=1'b0; q3_2=1'b0; q3_1=1'b0;
end
	  
always @(posedge clk or posedge reset)
	begin
		if(reset) begin
			q1_3<=1'b0; q1_2<=1'b0; q1_1<=1'b0; q2_3<=1'b0; q2_2<=1'b0; q2_1<=1'b0; q3_3<=1'b0; q3_2<=1'b0; q3_1<=1'b0; end
		else if(ce_d1) begin
			q1_3 <= d[0];
			q1_2 <= q1_3;   
			q1_1 <= q1_2; end
		else if(ce_d2) begin
			q2_3 <= d[1];
			q2_2 <= q2_3;   
			q2_1 <= q2_2; end
		else if(ce_d3) begin 
			q3_3 <= d[2];
			q3_2 <= q3_3;   
			q3_1 <= q3_2; end		
	end
endmodule


// RLBP Demuxer 
module rlbp_demux (data_in, data_sel, data_out);
		input data_in;
		input [1:0] data_sel; 
		output reg [3:0] data_out;
		
		always @(data_in, data_sel) 
		begin
			case (data_sel)
   			2'b00 : begin data_out[3:0] = 0; end 
			//First Row
			2'b01 : begin data_out[0] = data_in; data_out[3:1] = 0; end 
			2'b01 : begin data_out[0] = data_in; data_out[3:1] = 0; end 
			2'b01 : begin data_out[0] = data_in; data_out[3:1] = 0; end 	
			//Second Row
			2'b10 : begin data_out[1] = data_in; data_out[0] = 0; end 
			2'b10 : begin data_out[1] = data_in; data_out[0] = 0; end 
			2'b10 : begin data_out[1] = data_in; data_out[0] = 0; end 
			//Third Row
			2'b11 : begin data_out[2] = data_in; data_out[1:0] = 0; end 
			2'b11 : begin data_out[2] = data_in; data_out[1:0] = 0; end 
			2'b11 : begin data_out[2] = data_in; data_out[1:0] = 0; end 
			
			default : begin data_out[3:0] = 0; end
	    		endcase   
		end
endmodule

// Complete Module Instantiation and Wiring

module rlbp (clk, ce_d1, ce_d2, ce_d3, reset, reset_fsm, gpio_start, logic_analyzer_start, control_signals, rlbp_done, data_in, data_sel, data_out, d, q1_3, q1_2, q1_1, q2_3, q2_2, q2_1, q3_3, q3_2, q3_1);
	input clk, ce_d1, ce_d2, ce_d3, reset, gpio_start, logic_analyzer_start, data_in;
	input [1:0] data_sel;  
	input [3:0] d;
	output [3:0] data_out;
	output [1:0] control_signals;
	output reset_fsm, rlbp_done, q1_3, q1_2, q1_1, q2_3, q2_2, q2_1, q3_3, q3_2, q3_1;


//Define internal nets for wiring
	wire ce_d1_net, ce_d2_net, ce_d3_net;
	wire [1:0] sel_net;
	wire [3:0] data_net;
	assign sel_net = control_signals;
	assign data_net = data_out;	
	assign ce_d1_net = ce_d1;
	assign ce_d2_net = ce_d2;
	assign ce_d3_net = ce_d3;
	
	rlbp_fsm inst1(
	.clk(clk), 
	.reset(reset), 
	.reset_fsm(reset_fsm),
	.gpio_start(gpio_start), 
	.logic_analyzer_start(logic_analyzer_start),
	.ce_d1(ce_d1), 
	.ce_d2(ce_d2), 
	.ce_d3(ce_d3),
	.rlbp_done(rlbp_done),
	.control_signals(control_signals)	
	);
	
	shift_register inst2(
	.clk(clk),
	.ce_d1(ce_d1_net), 
	.ce_d2(ce_d2_net), 
	.ce_d3(ce_d3_net),
	.reset(reset),
	.d(data_net),
	.q1_3(q1_3), 
	.q1_2(q1_2), 
	.q1_1(q1_1), 
	.q2_3(q2_3), 
	.q2_2(q2_2), 
	.q2_1(q2_1), 
	.q3_3(q3_3), 
	.q3_2(q3_2), 
	.q3_1(q3_1)
	);
		
	rlbp_demux inst3(
	.data_in(data_in),
	.data_sel(sel_net),
	.data_out(data_out)
	);
	
endmodule

