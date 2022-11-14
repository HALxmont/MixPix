//
// RLBP FSM
//
module rlbp_fsm (clk, reset, reset_fsm, start, ce_d1, ce_d2, ce_d3, pxl_done_i, control_signals, rlbp_done, p2s_en);
	input clk, reset, start, pxl_done_i;
	output reg reset_fsm, ce_d1, ce_d2, ce_d3, rlbp_done, p2s_en;
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

	always @(state_rlbp or start or pxl_done_i)// or start or logic_analyzer_start) 
	begin
		case (state_rlbp)
			RESET_RLBP:	if (start==1'b0) begin
						next_state_rlbp = RESET_RLBP; end
					//else if (start==1'b1) begin
					//	next_state_rlbp = RESET_RLBP; end
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


			WAIT: 	if (start==1'b0) begin
						next_state_rlbp = RESET_RLBP; end
				//	else if (start==1'b1) begin
				//		next_state_rlbp = RESET_RLBP; end
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
					p2s_en = 1'b0;
					end
			S_REG_1_3:	begin
					reset_fsm = 1'b0;
					control_signals = 2'b01;
					ce_d1 = 1'b1;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					p2s_en = 1'b0;
					end
			S_REG_1_2:	begin
					reset_fsm = 1'b0;
					control_signals = 2'b01;
					ce_d1 = 1'b1;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					p2s_en = 1'b0;
					end
			S_REG_1_1:	begin
					reset_fsm = 1'b0;
					control_signals = 2'b01;
					ce_d1 = 1'b1;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					p2s_en = 1'b0;
					end
			S_REG_2_3:	begin
					reset_fsm = 1'b0;
					control_signals = 2'b10;
					ce_d1 = 1'b0;
					ce_d2 = 1'b1;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					p2s_en = 1'b0;
					end
			S_REG_2_2:	begin
					reset_fsm = 1'b0;
					control_signals = 2'b10;
					ce_d1 = 1'b0;
					ce_d2 = 1'b1;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					p2s_en = 1'b0;
					end
			S_REG_2_1:	begin
					reset_fsm = 1'b0;
					control_signals = 2'b10;
					ce_d1 = 1'b0;
					ce_d2 = 1'b1;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					p2s_en = 1'b0;
					end
			S_REG_3_3:	begin
					reset_fsm = 1'b0;
					control_signals = 2'b11;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b1;
					rlbp_done = 1'b0;
					p2s_en = 1'b0;					
					end
			S_REG_3_2:	begin
					reset_fsm = 1'b0;
					control_signals = 2'b11;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b1;
					rlbp_done = 1'b0;
					p2s_en = 1'b0;					
					end		
			S_REG_3_1:	begin
					reset_fsm = 1'b0;
					control_signals = 2'b11;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b1;
					rlbp_done = 1'b1;
					p2s_en = 1'b1;					
					end
			WAIT:		begin
					reset_fsm = 1'b0;
					control_signals = 2'b00;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b1;
					p2s_en = 1'b1;					
					end
			IDLE_0:		begin
					reset_fsm = 1'b0;
					control_signals = 2'b00;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					p2s_en = 1'b0;					
					end
			IDLE_1:		begin
					reset_fsm = 1'b0;
					control_signals = 2'b00;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					p2s_en = 1'b0;					
					end
			IDLE_2:		begin
					reset_fsm = 1'b0;
					control_signals = 2'b00;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					p2s_en = 1'b0;					
					end
			IDLE_3:		begin
					reset_fsm = 1'b0;
					control_signals = 2'b00;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					p2s_en = 1'b0;					
					end
			IDLE_4:		begin
					reset_fsm = 1'b0;
					control_signals = 2'b00;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					p2s_en = 1'b0;					
					end
					
			IDLE_5:		begin
					reset_fsm = 1'b0;
					control_signals = 2'b00;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					p2s_en = 1'b0;					
					end
			IDLE_6:		begin
					reset_fsm = 1'b0;
					control_signals = 2'b00;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					p2s_en = 1'b0;					
					end
			IDLE_7:		begin
					reset_fsm = 1'b0;
					control_signals = 2'b00;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					p2s_en = 1'b0;					
					end
			IDLE_8:		begin
					reset_fsm = 1'b0;
					control_signals = 2'b00;
					ce_d1 = 1'b0;
					ce_d2 = 1'b0;
					ce_d3 = 1'b0;
					rlbp_done = 1'b0;
					p2s_en = 1'b0;					
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

//
// Signal 1 FSM VD1
//
module vd1_fsm (clk, reset, count, time_up_vd1, time_down_vd1, vd1);
	input clk, reset;
	input [11:0] count;
	input [11:0] time_up_vd1, time_down_vd1;
	output reg vd1;
	reg [1:0] state;
	reg [1:0] next_state;
	//reg [9:0] time_up_vd1, time_down_vd1;
	
	parameter IDLE = 2'b00; parameter INITIAL_STATE = 2'b01; parameter FINAL_STATE = 2'b10;

	initial begin
		state = 2'b00;
	//	time_up_vd1 = 1000; //10us equals to 1000 counts of 10ns (10MHz)
	//	time_down = 2000; //20 us
	end
	
	always @(posedge clk or posedge reset)
	begin
		if (reset) state <= IDLE;
		else state <= next_state;
	end
	
	//Comparar entre counter y time_up/time_down, si counter alcanza valor
	//de time_up/time_down -> pasa a siguiente etapa

	always @(state or count)
	begin
		case (state)
			IDLE:		next_state = INITIAL_STATE;

			INITIAL_STATE:	if (count==time_up_vd1)
						next_state = FINAL_STATE;
					else
						next_state = INITIAL_STATE;

			FINAL_STATE: 	if ((count-time_up_vd1)==time_down_vd1)
						next_state = IDLE;
					else 
						next_state = FINAL_STATE;
		endcase
	end
	
	always @(state)
	begin
		case (state)
			IDLE: 		begin
					vd1 = 1'b0;
					end
							
			INITIAL_STATE:	begin
					vd1 = 1'b1;
					end
					
			FINAL_STATE:	begin
					vd1 = 1'b0;
					end
		endcase
	end

endmodule


//
// Signal 2 FSM VD2
//
module vd2_fsm (clk, reset, count, time_up_vd2, time_down_vd2, vd2);
	input clk, reset;
	input [11:0] count;
	input [11:0] time_up_vd2, time_down_vd2;
	output reg vd2;
	reg [1:0] state;
	reg [1:0] next_state;
	
	parameter IDLE = 2'b00; parameter INITIAL_STATE = 2'b01; parameter FINAL_STATE = 2'b10;

	initial begin
		state = 2'b00;
	end
	
	always @(posedge clk or posedge reset)
	begin
		if (reset) state <= IDLE;
		else state <= next_state;
	end
	
	//Comparar entre counter y time_up/time_down, si counter alcanza valor
	//de time_up/time_down -> pasa a siguiente etapa

	always @(state or count)
	begin
		case (state)
			IDLE:		next_state = INITIAL_STATE;

			INITIAL_STATE:	if (count==time_down_vd2)
						next_state = FINAL_STATE;
					else
						next_state = INITIAL_STATE;

			FINAL_STATE: 	if ((count-time_down_vd2)==time_up_vd2)
						next_state = IDLE;
					else 
						next_state = FINAL_STATE;
		endcase
	end
	
	always @(state)
	begin
		case (state)
			IDLE: 		begin
					vd2 = 1'b0;
					end
							
			INITIAL_STATE:	begin
					vd2 = 1'b0;
					end
					
			FINAL_STATE:	begin
					vd2 = 1'b1;
					end
		endcase
	end

endmodule

//
// Signal 3 FSM SW1
//
module sw1_fsm (clk, reset, count, time_up_sw1, time_down_sw1, sw1);
	input clk, reset;
	input [11:0] count;
	input [11:0] time_up_sw1, time_down_sw1;
	output reg sw1;
	reg [1:0] state;
	reg [1:0] next_state;
	
	parameter IDLE = 2'b00; parameter INITIAL_STATE = 2'b01; parameter FINAL_STATE = 2'b10;

	initial begin
		state = 2'b00;
	end
	
	always @(posedge clk or posedge reset)
	begin
		if (reset) state <= IDLE;
		else state <= next_state;
	end
	
	//Comparar entre counter y time_up/time_down, si counter alcanza valor
	//de time_up/time_down -> pasa a siguiente etapa

	always @(state or count)
	begin
		case (state)
			IDLE:		next_state = INITIAL_STATE;

			INITIAL_STATE:	if (count==time_up_sw1)
						next_state = FINAL_STATE;
					else
						next_state = INITIAL_STATE;

			FINAL_STATE: 	if ((count-time_up_sw1)==time_down_sw1)
						next_state = IDLE;
					else 
						next_state = FINAL_STATE;
		endcase
	end
	
	always @(state)
	begin
		case (state)
			IDLE: 		begin
					sw1 = 1'b0;
					end
							
			INITIAL_STATE:	begin
					sw1 = 1'b1;
					end
					
			FINAL_STATE:	begin
					sw1 = 1'b0;
					end
		endcase
	end

endmodule

//
// Signal 4 FSM SW2
//
module sw2_fsm (clk, reset, count, time_up_sw2, time_down_sw2, sw2);
	input clk, reset;
	input [11:0] count;
	input [11:0] time_up_sw2, time_down_sw2;
	output reg sw2;
	reg [1:0] state;
	reg [1:0] next_state;
	
	parameter IDLE = 2'b00; parameter INITIAL_STATE = 2'b01; parameter FINAL_STATE = 2'b10;

	initial begin
		state = 2'b00;
	end
	
	always @(posedge clk or posedge reset)
	begin
		if (reset) state <= IDLE;
		else state <= next_state;
	end
	
	//Comparar entre counter y time_up/time_down, si counter alcanza valor
	//de time_up/time_down -> pasa a siguiente etapa

	always @(state or count)
	begin
		case (state)
			IDLE:		next_state = INITIAL_STATE;

			INITIAL_STATE:	if (count==time_down_sw2)
						next_state = FINAL_STATE;
					else
						next_state = INITIAL_STATE;

			FINAL_STATE: 	if ((count-time_down_sw2)==time_up_sw2)
						next_state = IDLE;
					else 
						next_state = FINAL_STATE;
		endcase
	end
	
	always @(state)
	begin
		case (state)
			IDLE: 		begin
					sw2 = 1'b0;
					end
							
			INITIAL_STATE:	begin
					sw2 = 1'b0;
					end
					
			FINAL_STATE:	begin
					sw2 = 1'b1;
					end
		endcase
	end

endmodule

//
// Signal 5 FSM SH
//
module sh_fsm (clk, reset, count, time_up_sh, time_down_sh, sh);
	input clk, reset;
	input [11:0] count;
	input [11:0] time_up_sh, time_down_sh;
	output reg sh;
	reg [1:0] state;
	reg [1:0] next_state;
	
	parameter IDLE = 2'b00; parameter INITIAL_STATE = 2'b01; parameter FINAL_STATE = 2'b10;

	initial begin
		state = 2'b00;
	end
	
	always @(posedge clk or posedge reset)
	begin
		if (reset) state <= IDLE;
		else state <= next_state;
	end
	
	//Comparar entre counter y time_up/time_down, si counter alcanza valor
	//de time_up/time_down -> pasa a siguiente etapa

	always @(state or count)
	begin
		case (state)
			IDLE:		next_state = INITIAL_STATE;

			INITIAL_STATE:	if (count==time_down_sh)
						next_state = FINAL_STATE;
					else
						next_state = INITIAL_STATE;

			FINAL_STATE: 	if ((count-time_down_sh)==time_up_sh)
						next_state = IDLE;
					else 
						next_state = FINAL_STATE;
		endcase
	end
	
	always @(state)
	begin
		case (state)
			IDLE: 		begin
					sh = 1'b0;
					end
							
			INITIAL_STATE:	begin
					sh = 1'b0;
					end
					
			FINAL_STATE:	begin
					sh = 1'b1;
					end
		endcase
	end

endmodule

//
// Signal 6 FSM SH_CMP 
//
module sh_cmp_fsm (clk, reset, count, time_up_sh_cmp, time_down_sh_cmp, sh_cmp);
	input clk, reset;
	input [11:0] count;
	input [11:0] time_up_sh_cmp, time_down_sh_cmp;
	output reg sh_cmp;
	reg [1:0] state;
	reg [1:0] next_state;
	
	parameter IDLE = 2'b00; parameter INITIAL_STATE = 2'b01; parameter FINAL_STATE = 2'b10;

	initial begin
		state = 2'b00;
	end
	
	always @(posedge clk or posedge reset)
	begin
		if (reset) state <= IDLE;
		else state <= next_state;
	end
	
	//Comparar entre counter y time_up/time_down, si counter alcanza valor
	//de time_up/time_down -> pasa a siguiente etapa

	always @(state or count)
	begin
		case (state)
			IDLE:		next_state = INITIAL_STATE;

			INITIAL_STATE:	if (count==time_down_sh_cmp)
						next_state = FINAL_STATE;
					else
						next_state = INITIAL_STATE;

			FINAL_STATE: 	if ((count-time_down_sh_cmp)==time_up_sh_cmp)
						next_state = IDLE;
					else 
						next_state = FINAL_STATE;
		endcase
	end
	
	always @(state)
	begin
		case (state)
			IDLE: 		begin
					sh_cmp = 1'b0;
					end
							
			INITIAL_STATE:	begin
					sh_cmp = 1'b0;
					end
					
			FINAL_STATE:	begin
					sh_cmp = 1'b1;
					end
		endcase
	end

endmodule

//
// Signal 7 FSM SH_RST
//
module sh_reset_fsm (clk, reset, count, time_up_sh_reset, time_down_sh_reset, sh_reset);
	input clk, reset;
	input [11:0] count;
	input [11:0] time_up_sh_reset, time_down_sh_reset;
	output reg sh_reset;
	reg [1:0] state;
	reg [1:0] next_state;
	
	parameter IDLE = 2'b00; parameter INITIAL_STATE = 2'b01; parameter FINAL_STATE = 2'b10;

	initial begin
		state = 2'b00;
	end
	
	always @(posedge clk or posedge reset)
	begin
		if (reset) state <= IDLE;
		else state <= next_state;
	end
	
	//Comparar entre counter y time_up/time_down, si counter alcanza valor
	//de time_up/time_down -> pasa a siguiente etapa

	always @(state or count)
	begin
		case (state)
			IDLE:		next_state = INITIAL_STATE;

			INITIAL_STATE:	if (count==time_down_sh_reset)
						next_state = FINAL_STATE;
					else
						next_state = INITIAL_STATE;

			FINAL_STATE: 	if ((count-time_down_sh_reset)==time_up_sh_reset)
						next_state = IDLE;
					else 
						next_state = FINAL_STATE;
		endcase
	end
	
	always @(state)
	begin
		case (state)
			IDLE: 		begin
					sh_reset = 1'b0;
					end
							
			INITIAL_STATE:	begin
					sh_reset = 1'b0;
					end
					
			FINAL_STATE:	begin
					sh_reset = 1'b1;
					end
		endcase
	end

endmodule

//
// Signal 8 Counter Reset
//
module counter_reset_out_fsm (clk, reset, count, time_up_counter_reset_out, time_down_counter_reset_out, counter_reset_out);
	input clk, reset;
	input [11:0] count;
	input [11:0] time_up_counter_reset_out, time_down_counter_reset_out;
	output reg counter_reset_out;
	reg [1:0] state;
	reg [1:0] next_state;
	
	parameter IDLE = 2'b00; parameter INITIAL_STATE = 2'b01; parameter FINAL_STATE = 2'b10;

	initial begin
		state = 2'b00;
	end
	
	always @(posedge clk or posedge reset)
	begin
		if (reset) state <= IDLE;
		else state <= next_state;
	end
	
	//Comparar entre counter y time_up/time_down, si counter alcanza valor
	//de time_up/time_down -> pasa a siguiente etapa

	always @(state or count)
	begin
		case (state)
			IDLE:		next_state = INITIAL_STATE;

			INITIAL_STATE:	if (count==time_down_counter_reset_out)
						next_state = FINAL_STATE;
					else
						next_state = INITIAL_STATE;

			FINAL_STATE: 	if ((count-time_down_counter_reset_out)==time_up_counter_reset_out)
						next_state = IDLE;
					else 
						next_state = FINAL_STATE;
		endcase
	end
	
	always @(state)
	begin
		case (state)
			IDLE: 		begin
					counter_reset_out = 1'b1;
					end
							
			INITIAL_STATE:	begin
					counter_reset_out = 1'b0;
					end
					
			FINAL_STATE:	begin
					counter_reset_out = 1'b0;
					end
		endcase
	end

endmodule


//
// 12-bit Counter with Enable
//
module counter (clk, counter_reset, start, q);
	input clk, counter_reset, start;
	output [11:0] q;
	reg [11:0] tmp;

	always @(posedge clk)
	begin
		if (counter_reset)
			tmp <= 12'b000000000000;

		else begin 
			if (start == 0) 
				tmp <= 0;
			else
				tmp <= tmp + 1;
		end

	end

	assign q = tmp;

endmodule




// Complete Module Instantiation and Wiring

module rlbp (clk, ce_d1, ce_d2, ce_d3, reset, reset_fsm, start, control_signals, rlbp_done, p2s_en, pxl_done_i, data_in, data_sel, data_out, d, q1_3, q1_2, q1_1, q2_3, q2_2, q2_1, q3_3, q3_2, q3_1, en, p_data_in, s_data_out, ready, count, time_up_vd1, time_down_vd1, vd1, time_up_vd2, time_down_vd2, vd2, time_up_sw1, time_down_sw1, sw1, time_up_sw2, time_down_sw2, sw2, time_up_sh, time_down_sh, sh, time_up_sh_cmp, time_down_sh_cmp, sh_cmp, time_up_sh_reset, time_down_sh_reset, sh_reset, time_up_counter_reset_out, time_down_counter_reset_out, counter_reset_out, counter_reset, q, ext_clk, wb_clk_macro, sel_clk, clk_out, ext_reset, wb_reset, sel_reset, reset_out, ext_start, wb_start, sel_start, start_out, ext_clk_sync, wb_reset_sync, ext_reset_sync, wb_start_sync, ext_start_sync, ext_clk_temp, wb_reset_temp, ext_reset_temp, wb_start_temp, ext_start_temp);
	//clk, ce_d1, ce_d2, ce_d3, reset, reset_fsm, start, logic_analyzer_start, control_signals, rlbp_done, data_in, data_sel, data_out, d, q1_3, q1_2, q1_1, q2_3, q2_2, q2_1, q3_3, q3_2, q3_1
	
	input clk, ce_d1, ce_d2, ce_d3, reset, start, pxl_done_i, data_in, en;
	input counter_reset;
	input [1:0] data_sel;  
	input [3:0] d;
	input [7:0] p_data_in;
	input [11:0] time_up_vd1, time_down_vd1, time_up_vd2, time_down_vd2, time_up_sw1, time_down_sw1, time_up_sw2, time_down_sw2, time_up_sh, time_down_sh, time_up_sh_cmp, time_down_sh_cmp, time_up_sh_reset, time_down_sh_reset, time_up_counter_reset_out, time_down_counter_reset_out;
	input [11:0] count; //input a (triggers) FSMs 
	input ext_clk, wb_clk_macro, sel_clk, ext_reset, wb_reset, sel_reset, ext_start, wb_start, sel_start;
	output [3:0] data_out;
	output [1:0] control_signals;
	output reset_fsm, rlbp_done, p2s_en, q1_3, q1_2, q1_1, q2_3, q2_2, q2_1, q3_3, q3_2, q3_1;
	output s_data_out, ready;
	output vd1, vd2, sw1, sw2, sh, sh_cmp, sh_reset, counter_reset_out;	//counter_reset_out 
	output [11:0] q; //output counter
	inout clk_out, reset_out, start_out;
	output reg ext_clk_sync, wb_reset_sync, ext_reset_sync, wb_start_sync, ext_start_sync;
 	output reg ext_clk_temp, wb_reset_temp, ext_reset_temp, wb_start_temp, ext_start_temp;

//Syncronizers for Clock, Reset and Enable Signals
//Clock External Signal Synchronized

	always @(posedge wb_clk_macro)
	begin 
		ext_clk_temp <= ext_clk;
		ext_clk_sync <= ext_clk_temp;
	end

//Reset Signals Synchronized

	// always @(posedge clk_out)
	// begin
	// 	wb_reset_temp <= wb_reset;
	// 	wb_reset_sync <= wb_reset_temp;	
	// end	
	
	
	always @(posedge wb_clk_macro)
	begin
		ext_reset_temp <= ext_reset;
		ext_reset_sync <= ext_reset_temp;	
	end	
	

//Counter Enable Signals Sychronized	
	
	// always @(posedge clk_out)
	// begin
	// 	wb_start_temp <= wb_start;
	// 	wb_start_sync <= wb_start_temp;	
	// end
	
	always @(posedge wb_clk_macro)
	begin
		ext_start_temp <= ext_start;
		ext_start_sync <= ext_start_temp;	
	end



//Multiplexers for Clock, Reset and Enable

	assign clk_out = sel_clk ? ext_clk_sync : wb_clk_macro;
	assign reset_out = sel_reset ? ext_reset_sync : wb_reset_sync;
	assign start_out = sel_start ? ext_start_sync : wb_start_sync;




//Define internal nets for wiring
	wire ce_d1_net, ce_d2_net, ce_d3_net;
	wire p2s_en_net;
	wire [1:0] sel_net;
	wire [3:0] data_net;
	wire [7:0] p_data_in_net;
	wire counter_reset_net;
	wire [11:0] count_net;
	wire clk_out_net, reset_out_net, start_out_net;
	wire pxl_done_net;
	assign sel_net = control_signals;
	assign data_net = data_out;	
	assign ce_d1_net = ce_d1;
	assign ce_d2_net = ce_d2;
	assign ce_d3_net = ce_d3;
	assign p2s_en_net = p2s_en;
//	assign p_data_in_net = {q1_3, q1_2, q1_1, q2_3, q2_2, q2_1, q3_3, q3_2, q3_1};
	assign p_data_in_net = {q3_1, q3_2, q3_3, q2_1, q2_2, q2_3, q1_1, q1_2, q1_3};
	assign counter_reset_net = counter_reset_out;
	assign count_net = q;
	assign clk_out_net = clk_out;
	assign reset_out_net = reset_out;
	assign start_out_net = start_out;
	assign pxl_done_net = sh_cmp;

	
	rlbp_fsm inst1(
	.clk(clk_out_net), 
	.reset(reset_out_net), 
	.reset_fsm(reset_fsm),
	.start(start_out_net), 
	.pxl_done_i(pxl_done_net),
	.ce_d1(ce_d1), 
	.ce_d2(ce_d2), 
	.ce_d3(ce_d3),
	.rlbp_done(rlbp_done),
	.p2s_en(p2s_en),	
	.control_signals(control_signals)	
	);
	
	shift_register inst2(
	.clk(clk_out_net),
	.ce_d1(ce_d1_net), 
	.ce_d2(ce_d2_net), 
	.ce_d3(ce_d3_net),
	.reset(reset_out_net),
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
	.clk(clk_out_net),
	.reset(reset_out_net),
	.en(p2s_en_net),
	.p_data_in(p_data_in_net),
	.s_data_out(s_data_out),
	.ready(ready)
	);
	
	vd1_fsm inst5(
	.clk(clk_out_net),
	.reset(reset_out_net),
	.count(count_net),
	.time_up_vd1(time_up_vd1),
	.time_down_vd1(time_down_vd1),
	.vd1(vd1)
	);
	
	vd2_fsm inst6(
	.clk(clk_out_net),
	.reset(reset_out_net),
	.count(count_net),
	.time_up_vd2(time_up_vd2),
	.time_down_vd2(time_down_vd2),
	.vd2(vd2)
	);
	
	sw1_fsm inst7(
	.clk(clk_out_net),
	.reset(reset_out_net),
	.count(count_net),
	.time_up_sw1(time_up_sw1),
	.time_down_sw1(time_down_sw1),
	.sw1(sw1)
	);
	
	sw2_fsm inst8(
	.clk(clk_out_net),
	.reset(reset_out_net),
	.count(count_net),
	.time_up_sw2(time_up_sw2),
	.time_down_sw2(time_down_sw2),
	.sw2(sw2)
	);
	
	sh_fsm inst9(
	.clk(clk_out_net),
	.reset(reset_out_net),
	.count(count_net),
	.time_up_sh(time_up_sh),
	.time_down_sh(time_down_sh),
	.sh(sh)
	);
	
	sh_cmp_fsm inst10(
	.clk(clk_out_net),
	.reset(reset_out_net),
	.count(count_net),
	.time_up_sh_cmp(time_up_sh_cmp),
	.time_down_sh_cmp(time_down_sh_cmp),
	.sh_cmp(sh_cmp)
	);	
	
	sh_reset_fsm inst11(
	.clk(clk_out_net),
	.reset(reset_out_net),
	.count(count_net),
	.time_up_sh_reset(time_up_sh_reset),
	.time_down_sh_reset(time_down_sh_reset),
	.sh_reset(sh_reset)
	);
	
	counter_reset_out_fsm inst12(
	.clk(clk_out_net),
	.reset(reset_out_net),
	.count(count_net),
	.time_up_counter_reset_out(time_up_counter_reset_out),
	.time_down_counter_reset_out(time_down_counter_reset_out),
	.counter_reset_out(counter_reset_out)
	);
	
	counter inst13(
	.clk(clk_out_net),
	.counter_reset(counter_reset_net),
	.start(start_out_net),
	.q(q)
	);
	
	
	
endmodule

