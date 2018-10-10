`timescale 1ns / 1ps

module huffman(
	clock,
	reset,
	next_0,
	next_1,
	next_2,
	next_3,
	next_4,
	next_5,
	next_6,
	next_7,
	next_8,
	next_9,
	next_10,
	next_11,
	next_12,
	next_13,
	next_14,
	next_15,
	sig_end,
	i_len_data,
	o_len_address,
	len_ena,
	len_wea,
    table_douta,
	table_ena,
	table_wea,
	table_addr,
	eob_length,
	eob_code
);
  
//-------------------------
//	Parameter
//-------------------------
	parameter INDEX_BIT   		= 9;
	parameter LEN_BIT     		= 4;
	parameter COUNT_BIT   		= 9;
	parameter LEN_ADDRESS 		= 9;
	parameter INDEX_COUNT 		= 19;
	parameter ADDR_BIT			= 7;
	
//-------------------------
//	Input ports
//-------------------------
	input reset;
	input clock;

//-------------------------
//	Ouput ports
//-------------------------
	output reg 		 	sig_end;
	output reg [14:0] 	eob_code;
	output reg [3:0] 	eob_length;

//-------------------------
//	Next
//-------------------------	
	input [COUNT_BIT*2-1:0] next_0;
	input [COUNT_BIT*2-1:0] next_1;
	input [COUNT_BIT*2-1:0] next_2;
	input [COUNT_BIT*2-1:0] next_3;
	input [COUNT_BIT*2-1:0] next_4;
	input [COUNT_BIT*2-1:0] next_5;
	input [COUNT_BIT*2-1:0] next_6;
	input [COUNT_BIT*2-1:0] next_7;
	input [COUNT_BIT*2-1:0] next_8;
	input [COUNT_BIT*2-1:0] next_9;
	input [COUNT_BIT*2-1:0] next_10;
	input [COUNT_BIT*2-1:0] next_11;
	input [COUNT_BIT*2-1:0] next_12;
	input [COUNT_BIT*2-1:0] next_13;
	input [COUNT_BIT*2-1:0] next_14;
	input [COUNT_BIT*2-1:0] next_15;

//-------------------------
//	Len
//-------------------------	
	input 	   [INDEX_BIT+LEN_BIT-1:0] 	i_len_data;
	output reg [LEN_ADDRESS-1:0] 		o_len_address;
	output reg 							len_ena;
	output reg 							len_wea;

//-------------------------
//	Huffman table
//-------------------------	
	output reg [ADDR_BIT-1:0] 		   	table_addr;
	output reg [INDEX_BIT-1:0] 			table_douta;
	output reg	 						table_ena;
	output reg 							table_wea;
	
//-------------------------
//	Register
//-------------------------	
	reg  [9:0] 	state;
	reg  [2:0] 	step;
	reg  [8:0] 	count;
	
	reg [COUNT_BIT*2-1:0] nnext_0;
	reg [COUNT_BIT*2-1:0] nnext_1;
	reg [COUNT_BIT*2-1:0] nnext_2;
	reg [COUNT_BIT*2-1:0] nnext_3;
	reg [COUNT_BIT*2-1:0] nnext_4;
	reg [COUNT_BIT*2-1:0] nnext_5;
	reg [COUNT_BIT*2-1:0] nnext_6;
	reg [COUNT_BIT*2-1:0] nnext_7;
	reg [COUNT_BIT*2-1:0] nnext_8;
	reg [COUNT_BIT*2-1:0] nnext_9;
	reg [COUNT_BIT*2-1:0] nnext_10;
	reg [COUNT_BIT*2-1:0] nnext_11;
	reg [COUNT_BIT*2-1:0] nnext_12;
	reg [COUNT_BIT*2-1:0] nnext_13;
	reg [COUNT_BIT*2-1:0] nnext_14;
	reg [COUNT_BIT*2-1:0] nnext_15;	
	
	always@(posedge clock) begin
		if (reset) begin
			state 			<= 0;
			step			<= 0;
			nnext_0 		<= next_0;
			nnext_1 		<= next_1;
			nnext_2 		<= next_2;
			nnext_3 		<= next_3;
			nnext_4 		<= next_4;
			nnext_5 		<= next_5;
			nnext_6 		<= next_6;
			nnext_7 		<= next_7;
			nnext_8 		<= next_8;
			nnext_9 		<= next_9;
			nnext_10		<= next_10;
			nnext_11		<= next_11;
			nnext_12		<= next_12;
			nnext_13		<= next_13;
			nnext_14		<= next_14;
			nnext_15		<= next_15;
			o_len_address	<= 0;
			len_ena			<= 0;
			len_wea			<= 0;
			sig_end			<= 0;
			count			<= 0;
			table_addr		<= 0;
			table_douta		<= 0;
			table_wea		<= 0;
			table_ena		<= 0;
		end
	
		else if (count < INDEX_COUNT) begin
			case (step)
				0 : begin 
					step 			<= step + 1;
					
					o_len_address 	<= state;
					len_ena 		<= 1;
					len_wea 		<= 0;
					state			<= state + 1;					
				end
				
				1 : begin
					step 			<= step + 1;		
					
					o_len_address 	<= state;
					len_ena 		<= 1;
					len_wea 		<= 0;
					state			<= state + 1;				
				end
				
				2 : begin					
					o_len_address 	<= state;
					len_ena 		<= 1;
					len_wea 		<= 0;
					state			<= state + 1;	
	
					count 			<= count + 1;	
					table_wea		<= 1'b1;
					table_douta		<= i_len_data [LEN_BIT+INDEX_BIT-1:LEN_BIT];		

					case(i_len_data [LEN_BIT-1:0])		
						4'd0  : table_ena	<= 0;
						4'd1  : begin
							table_addr 		<= nnext_1; 
							nnext_1 		<= nnext_1 + 1;				
							table_ena		<= 1;
							if(i_len_data [LEN_BIT+INDEX_BIT-1:LEN_BIT] == 256) begin
								eob_code	<= nnext_1;
								eob_length	<= i_len_data [LEN_BIT-1:0];
							end
						end
						4'd2  : begin
							table_addr 		<= nnext_2; 
							nnext_2 		<= nnext_2 + 1;				
							table_ena		<= 1;
							if(i_len_data [LEN_BIT+INDEX_BIT-1:LEN_BIT] == 256) begin
								eob_code	<= nnext_2;
								eob_length	<= i_len_data [LEN_BIT-1:0];
							end
						end
						4'd3  : begin
							table_addr 		<= nnext_3; 
							nnext_3 		<= nnext_3 + 1;		
							table_ena		<= 1;
							if(i_len_data [LEN_BIT+INDEX_BIT-1:LEN_BIT] == 256) begin
								eob_code	<= nnext_3;
								eob_length	<= i_len_data [LEN_BIT-1:0];
							end
						end
						4'd4  : begin
							table_addr 		<= nnext_4; 
							nnext_4 		<= nnext_4 + 1;		
							table_ena		<= 1;
							if(i_len_data [LEN_BIT+INDEX_BIT-1:LEN_BIT] == 256) begin
								eob_code	<= nnext_4;
								eob_length	<= i_len_data [LEN_BIT-1:0];
							end
						end
						4'd5  : begin
							table_addr 		<= nnext_5; 
							nnext_5 		<= nnext_5 + 1;		
							table_ena		<= 1;
							if(i_len_data [LEN_BIT+INDEX_BIT-1:LEN_BIT] == 256) begin
								eob_code	<= nnext_5;
								eob_length	<= i_len_data [LEN_BIT-1:0];
							end
						end
						4'd6  : begin
							table_addr 		<= nnext_6; 
							nnext_6 		<= nnext_6 + 1;		
							table_ena		<= 1;
							if(i_len_data [LEN_BIT+INDEX_BIT-1:LEN_BIT] == 256) begin
								eob_code	<= nnext_6;
								eob_length	<= i_len_data [LEN_BIT-1:0];
							end
						end
						4'd7  : begin
							table_addr		<= nnext_7; 
							nnext_7 		<= nnext_7 + 1;		
							table_ena		<= 1;
							if(i_len_data [LEN_BIT+INDEX_BIT-1:LEN_BIT] == 256) begin
								eob_code	<= nnext_7;
								eob_length	<= i_len_data [LEN_BIT-1:0];
							end
						end
						4'd8  : begin
							table_addr 		<= nnext_8; 
							nnext_8 		<= nnext_8 + 1;		
							table_ena		<= 1;
							if(i_len_data [LEN_BIT+INDEX_BIT-1:LEN_BIT] == 256) begin
								eob_code	<= nnext_8;
								eob_length	<= i_len_data [LEN_BIT-1:0];
							end
						end
						4'd9  : begin
							table_addr 		<= nnext_9; 
							nnext_9 		<= nnext_9 + 1;		
							table_ena		<= 1;
							if(i_len_data [LEN_BIT+INDEX_BIT-1:LEN_BIT] == 256) begin
								eob_code	<= nnext_9;
								eob_length	<= i_len_data [LEN_BIT-1:0];
							end
						end
						4'd10 : begin
							table_addr 		<= nnext_10;
							nnext_10		<= nnext_10 + 1;		
							table_ena		<= 1;
							if(i_len_data [LEN_BIT+INDEX_BIT-1:LEN_BIT] == 256) begin
								eob_code	<= nnext_10;
								eob_length	<= i_len_data [LEN_BIT-1:0];
							end
						end
						4'd11 : begin
							table_addr 		<= nnext_11;
							nnext_11 		<= nnext_11 + 1;		
							table_ena		<= 1;
							if(i_len_data [LEN_BIT+INDEX_BIT-1:LEN_BIT] == 256) begin
								eob_code	<= nnext_11;
								eob_length	<= i_len_data [LEN_BIT-1:0];
							end
						end
						4'd12 : begin
							table_addr 		<= nnext_12;
							nnext_12 		<= nnext_12 + 1;		
							table_ena		<= 1;
							if(i_len_data [LEN_BIT+INDEX_BIT-1:LEN_BIT] == 256) begin
								eob_code	<= nnext_12;
								eob_length	<= i_len_data [LEN_BIT-1:0];
							end
						end
						4'd13 : begin
							table_addr 		<= nnext_13;
							nnext_13 		<= nnext_13 + 1;		
							table_ena		<= 1;
							if(i_len_data [LEN_BIT+INDEX_BIT-1:LEN_BIT] == 256) begin
								eob_code	<= nnext_13;
								eob_length	<= i_len_data [LEN_BIT-1:0];
							end
						end
						4'd14 : begin
							table_addr 		<= nnext_14;
							nnext_14 		<= nnext_14 + 1;		
							table_ena		<= 1;
							if(i_len_data [LEN_BIT+INDEX_BIT-1:LEN_BIT] == 256) begin
								eob_code	<= nnext_14;
								eob_length	<= i_len_data [LEN_BIT-1:0];
							end
						end
						4'd15 : begin
							table_addr 		<= nnext_15;
							nnext_15 		<= nnext_15 + 1;		
							table_ena		<= 1;
							if(i_len_data [LEN_BIT+INDEX_BIT-1:LEN_BIT] == 256) begin
								eob_code	<= nnext_15;
								eob_length	<= i_len_data [LEN_BIT-1:0];
							end
						end
					endcase
				end
			endcase
		end
			
		else begin
			sig_end 		<= 1;	
			table_ena		<= 0;
			table_wea		<= 0;	
			table_douta		<= 0;
			table_addr		<= 0;
		end	
	end
	
endmodule
	