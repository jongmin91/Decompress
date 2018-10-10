`timescale 1ns / 1ps

module count(
	clock,
	reset,
	in_data,
	add,
	ena,
	wea,
	out_0,
	out_1,
	out_2,
	out_3,
	out_4,
	out_5,
	out_6,
	out_7,
	out_8,
	out_9,
	out_10,
	out_11,
	out_12,
	out_13,
	out_14,	
	out_15,
	max,
	sig_end,
	error
);
//-------------------------
//	Parameter
//-------------------------
	parameter INDEX_BIT			= 4;
	parameter LEN_BIT 			= 3;
	parameter COUNT_BIT 		= 5;
	parameter LEN_ADDRESS		= 6;
	parameter INDEX_COUNT		= 19;
	
	localparam DATAWIDTH	 	= LEN_BIT + INDEX_BIT;
	
//-------------------------
//	Input ports
//-------------------------
	input clock;
	input reset;
	
//-------------------------
//	Module_test input
//-------------------------
	input [DATAWIDTH - 1:0] 		in_data;	
	
//-------------------------
//	Output ports
//-------------------------
	output reg [LEN_ADDRESS-1:0]	add;
	output reg 						ena;
	output reg 						wea;	

	output reg [COUNT_BIT-1:0] 		out_0;
	output reg [COUNT_BIT-1:0] 		out_1;
	output reg [COUNT_BIT-1:0] 		out_2;
	output reg [COUNT_BIT-1:0] 		out_3;
	output reg [COUNT_BIT-1:0] 		out_4;
	output reg [COUNT_BIT-1:0] 		out_5;
	output reg [COUNT_BIT-1:0] 		out_6;
	output reg [COUNT_BIT-1:0] 		out_7;
	output reg [COUNT_BIT-1:0] 		out_8;
	output reg [COUNT_BIT-1:0] 		out_9;
	output reg [COUNT_BIT-1:0] 		out_10;
	output reg [COUNT_BIT-1:0] 		out_11;
	output reg [COUNT_BIT-1:0] 		out_12;
	output reg [COUNT_BIT-1:0] 		out_13;
	output reg [COUNT_BIT-1:0] 		out_14;
	output reg [COUNT_BIT-1:0] 		out_15;	
	output reg [COUNT_BIT-1:0] 		max;
	output reg 						sig_end;
	output reg 						error;
	
//-------------------------
//	Register
//-------------------------	
	reg [LEN_BIT-1:0] 				find_max;
	reg [1:0] 						state;
	reg [8:0]						step;
	
	always @(posedge clock) begin	
		if(reset) begin
			out_0						<= 0;
			out_1						<= 0;
			out_2						<= 0;
			out_3						<= 0;
			out_4						<= 0;
			out_5						<= 0;
			out_6						<= 0;
			out_7						<= 0;
			out_8						<= 0;
			out_9						<= 0;
			out_10						<= 0;
			out_11						<= 0;
			out_12						<= 0;
			out_13						<= 0;
			out_14						<= 0;
			out_15						<= 0; 
			max							<= 0;
			state						<= 0;
			step						<= 0;
			sig_end 					<= 0;
			error						<= 0;
			add     					<= 0;
			ena     					<= 0;
			wea     					<= 0;
		end
		
		else if (step == INDEX_COUNT) begin
			sig_end 					<= 1;
			ena							<= 0;
		end
		
		else begin
			case(state)
				0 : begin
					add 				<= 0;
					wea					<= 0;
					ena 				<= 1;
					state				<= state + 1;
				end
				
				1 : begin
					add 				<= add + 1;
					state				<= state + 1;
				end
				
				2 : begin
					add 				<= add + 1;					
					find_max 			<= in_data[LEN_BIT-1:0];
					
					case(in_data[LEN_BIT-1:0])
						0	: out_0 	<= out_0;
						
						1	: begin 
							if(out_1 == 2) 	error 	<= 1;
							else 			out_1 	<= out_1 + 1;
						end
						2	: begin 
							if(out_2 == 4) 	error 	<= 1;
							else 			out_2 	<= out_2 + 1;
						end
						3	: begin 
							if(out_3 == 8) 	error 	<= 1;
							else 			out_3 	<= out_3 + 1;
						end
						4	: begin
							if(out_4 == 16) error 	<= 1;
							else 			out_4 	<= out_4 + 1;
						end
						5	: begin 
							if(out_5 == 32) error 	<= 1;
							else 			out_5 	<= out_5 + 1;
						end
						6	: begin 
							if(out_6 == 64) error 	<= 1;
							else 			out_6 	<= out_6 + 1;
						end
						7	: begin 
							if(out_7 == 128) error 	<= 1;
							else 			out_7 	<= out_7 + 1;
						end
						8	: begin 
							if(out_8 == 256) error 	<= 1;
							else 			out_8	<= out_8 + 1;
						end
						9	: begin
							if(out_9 == 512) error 	<= 1;
							else 			out_9	<= out_9 + 1;
						end
						10	: out_10	<= out_10 + 1;
						11	: out_11	<= out_11 + 1;
						12	: out_12	<= out_12 + 1;
						13	: out_13	<= out_13 + 1;
						14	: out_14	<= out_14 + 1;
						15	: out_15	<= out_15 + 1;
						default : error	<= 1;
					endcase
					
					step				<= step + 1;
					max 				<= (max < in_data[LEN_BIT-1:0]) ? in_data[LEN_BIT-1:0] : max;
				end
			endcase
		end
	end
	
endmodule
