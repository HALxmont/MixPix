//
// RLBP FSM
//
module rlbp_fsm (clk, reset, reset_fsm, gpio_start, ce_d1, ce_d2, ce_d3, logic_analyzer_start, pxl_done_i, control_signals, rlbp_done);
	input clk, reset, gpio_start, logic_analyzer_start, pxl_done_i;
	output reg reset_fsm, ce_d1, ce_d2, ce_d3, rlbp_done;
	output reg [1:0] control_signals;
	reg [4:0] state_rlbp;
	reg [4:0] next_state_rlbp;
	
	parameter RESET_RLBP = 5'b00000; parameter S_REG_1_3 = 5'b00001; parameter S_REG_1_2 = 5'b00011; parameter S_REG_1_1 = 5'b00101; 
	parameter S_REG_2_3 = 5'b00111; parameter S_REG_2_2 = 5'b01001; parameter S_REG_2_1 = 5'b01011; 
	parameter S_REG_3_3 = 5'b01101; parameter S_REG_3_2 = 5'b01111; parameter S_REG_3_1 = 5'b10001; parameter WAIT = 5'b10010; 
	
	parameter IDLE_1 = 5'b00010; parameter IDLE_2 = 5'b00100; parameter IDLE_3 = 5'b00110; parameter IDLE_4 = 5'b01000;
	parameter IDLE_5 = 5'b01010; parameter IDLE_6 = 5'b01100; parameter IDLE_7 = 5'b01110; parameter IDLE_8 = 5'b10000;
	parameter IDLE_0 = 5'b10011;     
	
	initial begin
		state_rlbp = 5'b00000;
		ce_d1 = 1'b0;
		ce_d2 = 1'b0;
		ce_d3 = 1'b0;
	end
	
	always @(posedge clk or posedge reset)
	begin
		if (reset) state_rlbp <= RESET_RLBP;
		else state_rlbp <= next_state_rlbp;
	end

	always @(state_rlbp or gpio_start or logic_analyzer_start or pxl_done_i)// or gpio_start or logic_analyzer_start) 
	begin
		case (state_rlbp)
			RESET_RLBP:	if (gpio_start==1'b0 && logic_analyzer_start==1'b0) begin
						next_state_rlbp = RESET_RLBP; end
					else if (gpio_start==1'b1 && logic_analyzer_start==1'b1) begin
						next_state_rlbp = RESET_RLBP; end
					else begin next_state_rlbp = IDLE_0; end
			S_REG_1_3:	next_state_rlbp = IDLE_1;
				
			S_REG_1_2:	next_state_rlbp = IDLE_2;
					
			S_REG_1_1:	next_state_rlbp = IDLE_3;
						
			S_REG_2_3:	next_state_rlbp = IDLE_4;						
					
			S_REG_2_2:	next_state_rlbp = IDLE_5; 
						
			S_REG_2_1:	next_state_rlbp = IDLE_6; 			
						
			S_REG_3_3:	next_state_rlbp = IDLE_7;
						
			S_REG_3_2:	next_state_rlbp = IDLE_8;
			
			S_REG_3_1:	next_state_rlbp = WAIT;


			WAIT: 	if (gpio_start==1'b0 && logic_analyzer_start==1'b0) begin
						next_state_rlbp = RESET_RLBP; end
					else if (gpio_start==1'b1 && logic_analyzer_start==1'b1) begin
						next_state_rlbp = RESET_RLBP; end
					else begin
						next_state_rlbp = WAIT; end
						
			IDLE_0:		if (pxl_done_i==1'b1) begin
						next_state_rlbp = S_REG_1_3; end
					else begin 
						next_state_rlbp = IDLE_0; end
						
			IDLE_1:		if (pxl_done_i==1'b1) begin
						next_state_rlbp = S_REG_1_2; end
					else begin 
						next_state_rlbp = IDLE_1; end
			
			IDLE_2:		if (pxl_done_i==1'b1) begin
						next_state_rlbp = S_REG_1_1; end
					else begin 
						next_state_rlbp = IDLE_2; end

			IDLE_3:		if (pxl_done_i==1'b1) begin
						next_state_rlbp = S_REG_2_3; end
					else begin 
						next_state_rlbp = IDLE_3; end		

			IDLE_4:		if (pxl_done_i==1'b1) begin
						next_state_rlbp = S_REG_2_2; end
					else begin 
						next_state_rlbp = IDLE_4; end	
			
			IDLE_5:		if (pxl_done_i==1'b1) begin
						next_state_rlbp = S_REG_2_1; end
					else begin 
						next_state_rlbp = IDLE_5; end

			IDLE_6:		if (pxl_done_i==1'b1) begin
						next_state_rlbp = S_REG_3_3; end
					else begin 
						next_state_rlbp = IDLE_6; end	
				
			IDLE_7:		if (pxl_done_i==1'b1) begin
						next_state_rlbp = S_REG_3_2; end
					else begin 
						next_state_rlbp = IDLE_7; end

			IDLE_8:		if (pxl_done_i==1'b1) begin
						next_state_rlbp = S_REG_3_1; end
					else begin 
						next_state_rlbp = IDLE_8; end	
							
			
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
			IDLE_0:		begin
					reset_fsm = 1'b0;
					control_signals = 2'b00;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					end
			IDLE_1:		begin
					reset_fsm = 1'b0;
					control_signals = 2'b00;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					end
			IDLE_2:		begin
					reset_fsm = 1'b0;
					control_signals = 2'b00;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					end
			IDLE_3:		begin
					reset_fsm = 1'b0;
					control_signals = 2'b00;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					end
			IDLE_4:		begin
					reset_fsm = 1'b0;
					control_signals = 2'b00;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					end
					
			IDLE_5:		begin
					reset_fsm = 1'b0;
					control_signals = 2'b00;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					end
			IDLE_6:		begin
					reset_fsm = 1'b0;
					control_signals = 2'b00;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					end
			IDLE_7:		begin
					reset_fsm = 1'b0;
					control_signals = 2'b00;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					end
			IDLE_8:		begin
					reset_fsm = 1'b0;
					control_signals = 2'b00;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
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

//Parallel to serial
module Parallel2Serial(clk, reset, en, p_data_in, s_data_out, ready);
	input clk, reset, en; 
	input [7:0] p_data_in;
	output reg  s_data_out;
	output reg ready;

//internal reg
	reg [3:0]  i;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            ready <= 0;
            s_data_out <= 0;
            i   <= 0;
        end

        else begin
            if(en) begin
                s_data_out <= p_data_in[i];     
                i <= i+1;
                
                if(i > 7) s_data_out <= 0; //force determinate state
                if(i == 8) ready <= 1;   //data is ready
                if(i == 8) i <= 15;      //finish the counter
                else ready <= 0;
            end         
        end
    end //end always

endmodule 



// Complete Module Instantiation and Wiring

module rlbp (clk, ce_d1, ce_d2, ce_d3, reset, reset_fsm, gpio_start, logic_analyzer_start, control_signals, rlbp_done, pxl_done_i, data_in, data_sel, data_out, d, q1_3, q1_2, q1_1, q2_3, q2_2, q2_1, q3_3, q3_2, q3_1, en, p_data_in, s_data_out, ready);
	//clk, ce_d1, ce_d2, ce_d3, reset, reset_fsm, gpio_start, logic_analyzer_start, control_signals, rlbp_done, data_in, data_sel, data_out, d, q1_3, q1_2, q1_1, q2_3, q2_2, q2_1, q3_3, q3_2, q3_1
	
	
	input clk, ce_d1, ce_d2, ce_d3, reset, gpio_start, logic_analyzer_start, pxl_done_i, data_in, en;
	input [1:0] data_sel;  
	input [3:0] d;
	input [7:0] p_data_in;
	output [3:0] data_out;
	output [1:0] control_signals;
	output reset_fsm, rlbp_done, q1_3, q1_2, q1_1, q2_3, q2_2, q2_1, q3_3, q3_2, q3_1;
	output s_data_out, ready;


//Define internal nets for wiring
	wire ce_d1_net, ce_d2_net, ce_d3_net;
	wire [1:0] sel_net;
	wire [3:0] data_net;
	wire [7:0] p_data_in_net;
	assign sel_net = control_signals;
	assign data_net = data_out;	
	assign ce_d1_net = ce_d1;
	assign ce_d2_net = ce_d2;
	assign ce_d3_net = ce_d3;
//	assign p_data_in_net = {q1_3, q1_2, q1_1, q2_3, q2_2, q2_1, q3_3, q3_2, q3_1};
	assign p_data_in_net = {q3_1, q3_2, q3_3, q2_1, q2_2, q2_3, q1_1, q1_2, q1_3};

	
	rlbp_fsm inst1(
	.clk(clk), 
	.reset(reset), 
	.reset_fsm(reset_fsm),
	.gpio_start(gpio_start), 
	.logic_analyzer_start(logic_analyzer_start),
	.pxl_done_i(pxl_done_i),
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
	
	Parallel2Serial inst4(
	.clk(clk),
	.reset(reset),
	.en(en),
	.p_data_in(p_data_in_net),
	.s_data_out(s_data_out),
	.ready(ready)
	);
	
	
	
endmodule

