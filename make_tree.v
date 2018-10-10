`timescale 1ns / 1ps

module make_tree(
	clock,
	reset,
	len_data,
	len_address,	
	len_ena,
	len_wea,
	sig_end,
    table_douta,
	table_ena,
	table_wea,
    table_addr,
	eob_code,
	eob_length,
	error,	
	huffman_1,
	huffman_2,
	huffman_3,
	huffman_4,
	huffman_5,
	huffman_6,
	huffman_7,
	huffman_8,
	huffman_9,
	huffman_10,
	huffman_11,
	huffman_12,
	huffman_13,
	huffman_14,
	huffman_15
);

	parameter INDEX_BIT 	 = 5;					
	parameter LEN_BIT 		 = 3;					
	parameter COUNT_BIT 	 = 5;					
	parameter LEN_ADDRESS	 = 5;					
	parameter INDEX_COUNT	 = 19;
	parameter ADDR_BIT		 = 7;
	
	localparam DATAWIDTH	 = LEN_BIT + INDEX_BIT;
	
	localparam state_idle	 = 7'b0000001;
	localparam state_count	 = 7'b0001000;
	localparam state_next	 = 7'b0010000;
	localparam state_huffman = 7'b0100000;
	localparam state_done	 = 7'b1000000;
	
//-------------------------
//	Input ports
//-------------------------		
	input 							clock;
	input 							reset;
	input [DATAWIDTH-1:0] 			len_data;
	
//-------------------------	
//	Output ports	
//-------------------------		
	output reg [LEN_ADDRESS-1:0]	len_address;
	output reg 						len_ena;
	output reg 						len_wea;
	output reg 						sig_end;
	
	output [INDEX_BIT-1:0] 			table_douta;
	output 							table_ena;
	output 							table_wea;
	output [ADDR_BIT-1:0] 			table_addr;
	
	output [14:0] 					eob_code;
	output [3:0] 					eob_length;
	
	output							error;
	
	output [COUNT_BIT*3-1:0]		huffman_1;
	output [COUNT_BIT*3-1:0]		huffman_2;
	output [COUNT_BIT*3-1:0]		huffman_3;
	output [COUNT_BIT*3-1:0]		huffman_4;
	output [COUNT_BIT*3-1:0]		huffman_5;
	output [COUNT_BIT*3-1:0]		huffman_6;
	output [COUNT_BIT*3-1:0]		huffman_7;
	output [COUNT_BIT*3-1:0]		huffman_8;
	output [COUNT_BIT*3-1:0]		huffman_9;
	output [COUNT_BIT*3-1:0]		huffman_10;
	output [COUNT_BIT*3-1:0]		huffman_11;
	output [COUNT_BIT*3-1:0]		huffman_12;
	output [COUNT_BIT*3-1:0]		huffman_13;
	output [COUNT_BIT*3-1:0]		huffman_14;
	output [COUNT_BIT*3-1:0]		huffman_15;
	
//-------------------------
//	Wire -count
//-------------------------
	reg 						reset_count;    
	
	wire [LEN_ADDRESS-1:0] 		len_address_count;
	wire 						len_ena_count;
	wire 						len_wea_count;
	
	wire [COUNT_BIT-1:0] 		count_0;          
	wire [COUNT_BIT-1:0] 		count_1;
	wire [COUNT_BIT-1:0] 		count_2;
	wire [COUNT_BIT-1:0] 		count_3;
	wire [COUNT_BIT-1:0] 		count_4;
	wire [COUNT_BIT-1:0] 		count_5;
	wire [COUNT_BIT-1:0] 		count_6;
	wire [COUNT_BIT-1:0] 		count_7;
	wire [COUNT_BIT-1:0] 		count_8;
	wire [COUNT_BIT-1:0] 		count_9;
	wire [COUNT_BIT-1:0] 		count_10;
	wire [COUNT_BIT-1:0] 		count_11;
	wire [COUNT_BIT-1:0] 		count_12;
	wire [COUNT_BIT-1:0] 		count_13;
	wire [COUNT_BIT-1:0] 		count_14;
	wire [COUNT_BIT-1:0] 		count_15;	
	wire [COUNT_BIT-1:0] 		max_count;
	wire 						sig_end_count;	
	
//-------------------------
//	Wire -next
//-------------------------
	reg  						reset_next;
	wire [COUNT_BIT*2-1:0]		next_0;
	wire [COUNT_BIT*2-1:0]		next_1;
	wire [COUNT_BIT*2-1:0]		next_2;
	wire [COUNT_BIT*2-1:0]		next_3;
	wire [COUNT_BIT*2-1:0]		next_4;
	wire [COUNT_BIT*2-1:0]		next_5;
	wire [COUNT_BIT*2-1:0]		next_6;
	wire [COUNT_BIT*2-1:0]		next_7;
	wire [COUNT_BIT*2-1:0]		next_8;
	wire [COUNT_BIT*2-1:0]		next_9;
	wire [COUNT_BIT*2-1:0]		next_10;
	wire [COUNT_BIT*2-1:0]		next_11;
	wire [COUNT_BIT*2-1:0]		next_12;
	wire [COUNT_BIT*2-1:0]		next_13;
	wire [COUNT_BIT*2-1:0]		next_14;
	wire [COUNT_BIT*2-1:0]		next_15;
	wire 						sig_end_next;
	
//-------------------------
//	Wire -huffman
//-------------------------
	wire 						sig_end_huffman;
	reg 						reset_huff;

	wire [LEN_ADDRESS-1:0] 		len_address_huff;
	wire 						len_ena_huff;
	wire 						len_wea_huff;
	
//-------------------------
//	Register
//-------------------------		
	reg [6:0] 	state;

count
#(
	.INDEX_BIT(INDEX_BIT),
	.LEN_BIT(LEN_BIT),
	.LEN_ADDRESS(LEN_ADDRESS),
	.COUNT_BIT(COUNT_BIT),
	.INDEX_COUNT(INDEX_COUNT)
)
count_(	
	.clock		(clock),
	.reset		(reset_count),
	.in_data	(len_data),
	.add		(len_address_count),
	.ena		(len_ena_count),
	.wea		(len_wea_count),
	.out_0		(count_0),
	.out_1		(count_1),
	.out_2		(count_2),
	.out_3		(count_3),
	.out_4		(count_4),
	.out_5		(count_5),
	.out_6		(count_6),
	.out_7		(count_7),
	.out_8		(count_8),
	.out_9		(count_9),
	.out_10		(count_10),
	.out_11		(count_11),
	.out_12		(count_12),
	.out_13		(count_13),
	.out_14		(count_14),
	.out_15		(count_15),
	.max		(max_count),
	.sig_end	(sig_end_count),
	.error		(error)
);

next
#(
	.COUNT_BIT(COUNT_BIT)
)
next_(
	.clock			(clock),
	.reset			(reset_next),
	.in_0			(count_0),
	.in_1			(count_1),
	.in_2			(count_2),
	.in_3			(count_3),
	.in_4			(count_4),
	.in_5			(count_5),
	.in_6			(count_6),
	.in_7			(count_7),
	.in_8			(count_8),
	.in_9			(count_9),
	.in_10			(count_10),
	.in_11			(count_11),
	.in_12			(count_12),
	.in_13			(count_13),
	.in_14			(count_14),	
	.in_15			(count_15),
	.max			(max_count),
	.next_out_0		(next_0),
	.next_out_1		(next_1),
	.next_out_2		(next_2),
	.next_out_3		(next_3),
	.next_out_4		(next_4),
	.next_out_5		(next_5),
	.next_out_6		(next_6),
	.next_out_7		(next_7),
	.next_out_8		(next_8),
	.next_out_9		(next_9),
	.next_out_10	(next_10),
	.next_out_11	(next_11),
	.next_out_12	(next_12),
	.next_out_13	(next_13),
	.next_out_14	(next_14),
	.next_out_15	(next_15),
	.sig_end		(sig_end_next)
);

huffman
#(
	.INDEX_BIT(INDEX_BIT),
	.LEN_BIT(LEN_BIT),
	.COUNT_BIT(COUNT_BIT),
	.LEN_ADDRESS(LEN_ADDRESS),
	.INDEX_COUNT(INDEX_COUNT),
	.ADDR_BIT(ADDR_BIT)
)
huffman_(
	.clock			(clock),
	.reset			(reset_huff),
	.next_0			(next_0),
	.next_1			(next_1),
	.next_2			(next_2),
	.next_3			(next_3),
	.next_4			(next_4),
	.next_5			(next_5),
	.next_6			(next_6),
	.next_7			(next_7),
	.next_8			(next_8),
	.next_9			(next_9),
	.next_10		(next_10),
	.next_11		(next_11),
	.next_12		(next_12),
	.next_13		(next_13),
	.next_14		(next_14),
	.next_15		(next_15),
	.sig_end		(sig_end_huffman),
	.i_len_data		(len_data),
	.o_len_address	(len_address_huff),
	.len_ena		(len_ena_huff),
	.len_wea		(len_wea_huff),
    .table_douta	(table_douta),
	.table_ena		(table_ena),
	.table_wea		(table_wea),
    .table_addr		(table_addr),
	.eob_length		(eob_length),
	.eob_code		(eob_code)
);
	
	assign huffman_1	= {next_1 ,  count_1};
	assign huffman_2	= {next_2 ,  count_2};
	assign huffman_3	= {next_3 ,  count_3};
	assign huffman_4	= {next_4 ,  count_4};
	assign huffman_5	= {next_5 ,  count_5};
	assign huffman_6	= {next_6 ,  count_6};
	assign huffman_7	= {next_7 ,  count_7};
	assign huffman_8	= {next_8 ,  count_8};
	assign huffman_9	= {next_9 ,  count_9};
	assign huffman_10	= {next_10, count_10};
	assign huffman_11	= {next_11, count_11};
	assign huffman_12	= {next_12, count_12};
	assign huffman_13	= {next_13, count_13};
	assign huffman_14	= {next_14, count_14};
	assign huffman_15	= {next_15, count_15};
	
	always@(*) begin
		case (state) 
			state_idle : begin			
				reset_count				<= 1;
				reset_next				<= 1;
				reset_huff				<= 1;
			end
			
			state_count : begin
				reset_count				<= 0;
				reset_next				<= 1;
				reset_huff				<= 1;
			end	
	
			state_next : begin
				reset_count				<= 0;
				reset_next				<= 0;
				reset_huff				<= 1;
			end
			
			state_huffman : begin
				reset_count				<= 0;
				reset_next				<= 0;
				reset_huff				<= 0;
			end
			
			state_done : begin
				reset_count				<= 0;
				reset_next				<= 0;
				reset_huff				<= 0;
			end
			
			default : begin
				reset_count				<= 1;
				reset_next 				<= 1;
				reset_huff 				<= 1;
			end
		endcase
	end
	
	always@(*) begin
		case (state) 
			state_done : begin
				sig_end 				<= 1;
			end
			
			default : begin
				sig_end 				<= 0;
			end
		endcase
	end
	
	always@(*) begin
		case (state) 
			state_count : begin
				len_wea 				<= len_wea_count;
				len_ena					<= len_ena_count;
				len_address				<= len_address_count;
			end	
			
			state_huffman : begin
				len_wea 				<= len_wea_huff;
				len_ena					<= len_ena_huff;
				len_address				<= len_address_huff;
			end
			
			default : begin
				len_wea 				<= 0;
				len_ena					<= 0;
				len_address				<= 0;
			end
		endcase
	end
	
	always@(posedge clock or posedge reset) begin
		if(reset) begin
			state <= state_idle;
		end
		
		else begin
			case(state)
				state_idle : state 	<= state_count;
				
				state_count : begin
					if(sig_end_count) state <= state_next;
					else state <= state_count;
				end

				state_next : begin
					if(sig_end_next) state <= state_huffman;
					else state <= state_next;
				end

				state_huffman : begin
					if(sig_end_huffman) state <= state_done;
					else state <= state_huffman;
				end

				state_done : state <= state_done;
				
				default : state <= state_idle;
			endcase
		end
	end

endmodule
