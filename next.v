`timescale 1ns / 1ps

module next(
	clock,
	reset,
	in_0,
	in_1,
	in_2,
	in_3,
	in_4,
	in_5,
	in_6,
	in_7,
	in_8,
	in_9,
	in_10,
	in_11,
	in_12,
	in_13,
	in_14,	
	in_15,
	max,
	next_out_0,
	next_out_1,
	next_out_2,
	next_out_3,
	next_out_4,
	next_out_5,
	next_out_6,
	next_out_7,
	next_out_8,
	next_out_9,
	next_out_10,
	next_out_11,
	next_out_12,
	next_out_13,
	next_out_14,
	next_out_15,
	sig_end
);

//-------------------------
//	Parameter
//-------------------------
	parameter COUNT_BIT = 5;

//-------------------------
//input ports
//-------------------------
	input reset;
	input clock;
	
//-------------------------
//	Module_test input
//-------------------------
	input [COUNT_BIT-1:0] in_0;
	input [COUNT_BIT-1:0] in_1;
	input [COUNT_BIT-1:0] in_2;
	input [COUNT_BIT-1:0] in_3;
	input [COUNT_BIT-1:0] in_4;
	input [COUNT_BIT-1:0] in_5;
	input [COUNT_BIT-1:0] in_6;
	input [COUNT_BIT-1:0] in_7;
	input [COUNT_BIT-1:0] in_8;
	input [COUNT_BIT-1:0] in_9;
	input [COUNT_BIT-1:0] in_10;
	input [COUNT_BIT-1:0] in_11;
	input [COUNT_BIT-1:0] in_12;
	input [COUNT_BIT-1:0] in_13;
	input [COUNT_BIT-1:0] in_14;
	input [COUNT_BIT-1:0] in_15;	
	input [COUNT_BIT-1:0] max;
	
//-------------------------
//output ports
//-------------------------	
	output reg [COUNT_BIT*2-1:0] next_out_0;
	output reg [COUNT_BIT*2-1:0] next_out_1;
	output reg [COUNT_BIT*2-1:0] next_out_2;
	output reg [COUNT_BIT*2-1:0] next_out_3;
	output reg [COUNT_BIT*2-1:0] next_out_4;
	output reg [COUNT_BIT*2-1:0] next_out_5;
	output reg [COUNT_BIT*2-1:0] next_out_6;
	output reg [COUNT_BIT*2-1:0] next_out_7;
	output reg [COUNT_BIT*2-1:0] next_out_8;
	output reg [COUNT_BIT*2-1:0] next_out_9;
	output reg [COUNT_BIT*2-1:0] next_out_10;
	output reg [COUNT_BIT*2-1:0] next_out_11;
	output reg [COUNT_BIT*2-1:0] next_out_12;
	output reg [COUNT_BIT*2-1:0] next_out_13;
	output reg [COUNT_BIT*2-1:0] next_out_14;
	output reg [COUNT_BIT*2-1:0] next_out_15;
	output reg sig_end;
	
	reg [4:0] step;
	



	always @(posedge clock) begin
		if(reset) begin
			next_out_0	<= 0;
			next_out_1	<= 0;
			next_out_2	<= 0;
			next_out_3	<= 0;
			next_out_4	<= 0;
			next_out_5	<= 0;
			next_out_6	<= 0;
			next_out_7	<= 0;
			next_out_8	<= 0;
			next_out_9	<= 0;
			next_out_10	<= 0;
			next_out_11	<= 0;
			next_out_12	<= 0;
			next_out_13	<= 0;
			next_out_14	<= 0;
			next_out_15	<= 0;
			step        <= 0;
			sig_end     <= 0;
		end
		
		else begin
			case(step)
				0	: begin
					next_out_0	<= 0;
					step 		<= step + 1;
				end
				1	: begin
					next_out_1	<= 0;
					step 		<= step + 1;
				end
				2	: begin
					next_out_2	<= (next_out_1 	+ in_1) << 1;
					step 		<= step + 1;
				end                                    
				3	: begin                            
					next_out_3	<= (next_out_2 	+ in_2) << 1;
					step 		<= step + 1;
				end                                    
				4	: begin                            
					next_out_4	<= (next_out_3 	+ in_3) << 1;
					step 		<= step + 1;
				end                                    
				5	: begin                            
					next_out_5	<= (next_out_4 	+ in_4) << 1;
					step 		<= step + 1;
				end                                    
				6	: begin                            
					next_out_6	<= (next_out_5 	+ in_5) << 1;
					step 		<= step + 1;
				end                                    
				7	: begin                            
					next_out_7	<= (next_out_6 	+ in_6) << 1;
					step 		<= step + 1;
				end                                    
				8	: begin                            
					next_out_8	<= (next_out_7	+ in_7) << 1;
					step 		<= step + 1;
				end                                    
				9	: begin                            
					next_out_9	<= (next_out_8	+ in_8) << 1;
					step 		<= step + 1;
				end                                    
				10	: begin                            
					next_out_10	<= (next_out_9 	+ in_9) << 1;
					step 		<= step + 1;
				end
				11	: begin
					next_out_11	<= (next_out_10	+ in_10) << 1;
					step 		<= step + 1;
				end                                     
				12	: begin                             
					next_out_12	<= (next_out_11	+ in_11) << 1;
					step 		<= step + 1;
				end                                     
				13	: begin                             
					next_out_13	<= (next_out_12	+ in_12) << 1;
					step 		<= step + 1;
				end                                     
				14	: begin                             
					next_out_14	<= (next_out_13	+ in_13) << 1;
					step 		<= step + 1;
				end                                     
				15	: begin                             
					next_out_15	<= (next_out_14	+ in_14) << 1;
					step 		<= step + 1;
				end
				default : sig_end   <= 1;
			endcase
		end
	end
	
endmodule
