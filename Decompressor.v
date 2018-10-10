
`timescale 1ns / 1ps

module Decompressor
#(		
	parameter 	Lite_DataWidth		= 32					,
	parameter 	Lite_AddrWidth		= 32					,
	parameter 	Full_DataWidth		= 32					,
	parameter 	Full_AddrWidth		= 32
)
(
    input                			iClock                  ,
    input                			iReset                  ,
    input                			S_AWVALID               ,
    output               			S_AWREADY               ,
    input   [Lite_AddrWidth-1:0]	S_AWADDR                ,
    input   [2:0]        			S_AWPROT                ,
    input                			S_WVALID                ,
    output               			S_WREADY                ,
    input   [Lite_DataWidth-1:0]	S_WDATA                 ,
    input   [Lite_DataWidth/8-1:0]	S_WSTRB                 ,
    output               			S_BVALID                ,
    input                			S_BREADY                ,
    output  [1:0]        			S_BRESP                 ,
    input                			S_ARVALID               ,
    output               			S_ARREADY               ,
    input   [Lite_AddrWidth-1:0]	S_ARADDR                ,
    input   [2:0]        			S_ARPROT                ,
    output               			S_RVALID                ,
    input                			S_RREADY                ,
    output  [Lite_DataWidth-1:0]	S_RDATA                 ,
    output  [1:0]        			S_RRESP                 ,

    output  [Full_AddrWidth-1:0]	M0_AWADDR               ,
    output  [7:0]        			M0_AWLEN                ,
    output  [2:0]        			M0_AWSIZE               ,
    output  [1:0]        			M0_AWBURST              ,
    output  [3:0]        			M0_AWCACHE              ,
    output  [2:0]        			M0_AWPROT               ,
    output               			M0_AWVALID              ,
    input                			M0_AWREADY              ,
    output  [Full_DataWidth-1:0]    M0_WDATA                ,
    output  [Full_DataWidth/8-1:0]  M0_WSTRB                ,
    output               			M0_WLAST                ,
    output               			M0_WVALID               ,
    input                			M0_WREADY               ,
    input   [1:0]        			M0_BRESP                ,
    input                			M0_BVALID               ,
    output               			M0_BREADY               ,

    output  [Full_AddrWidth-1:0]	M0_ARADDR               ,
    output  [7:0]        			M0_ARLEN                ,
    output  [2:0]        			M0_ARSIZE               ,
    output  [1:0]        			M0_ARBURST              ,
    output  [3:0]        			M0_ARCACHE              ,
    output  [2:0]        			M0_ARPROT               ,
    output               			M0_ARVALID              ,
    input                			M0_ARREADY              ,
    input   [Full_DataWidth-1:0]	M0_RDATA                ,
    input   [1:0]        			M0_RRESP                ,
    input                			M0_RLAST                ,
    input                			M0_RVALID               ,
    output               			M0_RREADY               ,

    output  [Full_AddrWidth-1:0]	M1_AWADDR               ,
    output  [7:0]        			M1_AWLEN                ,
    output  [2:0]        			M1_AWSIZE               ,
    output  [1:0]        			M1_AWBURST              ,
    output  [3:0]        			M1_AWCACHE              ,
    output  [2:0]        			M1_AWPROT               ,
    output               			M1_AWVALID              ,
    input                			M1_AWREADY              ,
    output  [Full_DataWidth-1:0]    M1_WDATA                ,
    output  [Full_DataWidth/8-1:0]	M1_WSTRB                ,
    output               			M1_WLAST                ,
    output               			M1_WVALID               ,
    input                			M1_WREADY               ,
    input   [1:0]        			M1_BRESP                ,
    input                			M1_BVALID               ,
    output               			M1_BREADY               ,

    output  [Full_AddrWidth-1:0]	M1_ARADDR               ,
    output  [7:0]        			M1_ARLEN                ,
    output  [2:0]        			M1_ARSIZE               ,
    output  [1:0]        			M1_ARBURST              ,
    output  [3:0]        			M1_ARCACHE              ,
    output  [2:0]        			M1_ARPROT               ,
    output               			M1_ARVALID              ,
    input                			M1_ARREADY              ,
    input   [Full_DataWidth-1:0]	M1_RDATA                ,
    input   [1:0]        			M1_RRESP                ,
    input                			M1_RLAST                ,
    input                			M1_RVALID               ,
    output               			M1_RREADY               
); 

	// Inner AXI-slave	Interface
    wire	    					start       			;
	wire	[Lite_DataWidth-1:0]	count					;
	wire	[Lite_DataWidth-1:0]	addr_in					;	
	wire	[Lite_DataWidth-1:0]	addr_out				;
    
    AXI4Lite_decomp
    #
    (
        .AddressWidth       		(Lite_AddrWidth  		),
        .DataWidth          		(Lite_DataWidth     	)
    )
    Slave_AXI4LiteInterface
    (
        .ACLK               		(iClock                 ),
        .ARESETN            		(iReset                	),
        .AWVALID            		(S_AWVALID              ),
        .AWREADY            		(S_AWREADY              ),
        .AWADDR             		(S_AWADDR               ),
        .AWPROT             		(S_AWPROT               ),
        .WVALID             		(S_WVALID               ),
        .WREADY             		(S_WREADY               ),
        .WDATA              		(S_WDATA                ),
        .WSTRB              		(S_WSTRB                ),
        .BVALID             		(S_BVALID               ),
        .BREADY             		(S_BREADY               ),
        .BRESP              		(S_BRESP                ),
        .ARVALID            		(S_ARVALID              ),
        .ARREADY            		(S_ARREADY              ),
        .ARADDR             		(S_ARADDR               ),
        .ARPROT             		(S_ARPROT               ),
        .RVALID             		(S_RVALID               ),
        .RREADY             		(S_RREADY               ),
        .RDATA              		(S_RDATA                ),
        .RRESP              		(S_RRESP                ),
		.start						(start       			),
        .addr_in	     			(addr_in				),
        .addr_out	     			(addr_out				),
        .count     					(count					)
    );
    
	AXI4Full_decomp
	#
	(
        .Lite_DataWidth				(Lite_DataWidth     	),
        .AddressWidth				(Full_AddrWidth  		),
        .DataWidth					(Full_DataWidth     	)
	)
	Master_AXI4FullInterface
	(
		.Clock          			(iClock					),
		.Reset          			(!iReset				),
		.A_AWADDR          			(M0_AWADDR        		),
		.A_AWLEN           			(M0_AWLEN         		),
		.A_AWSIZE          			(M0_AWSIZE        		),
		.A_AWBURST         			(M0_AWBURST       		),
		.A_AWCACHE         			(M0_AWCACHE       		),
		.A_AWPROT          			(M0_AWPROT        		),
		.A_AWVALID         			(M0_AWVALID       		),
		.A_AWREADY         			(M0_AWREADY       		),
		.A_WDATA           			(M0_WDATA         		),
		.A_WSTRB           			(M0_WSTRB         		),
		.A_WLAST           			(M0_WLAST         		),
		.A_WVALID          			(M0_WVALID        		),
		.A_WREADY          			(M0_WREADY        		),
		.A_BRESP           			(M0_BRESP         		),
		.A_BVALID          			(M0_BVALID        		),
		.A_BREADY          			(M0_BREADY        		),
		.A_ARADDR          			(M0_ARADDR        		),
		.A_ARLEN           			(M0_ARLEN         		),
		.A_ARSIZE          			(M0_ARSIZE        		),
		.A_ARBURST         			(M0_ARBURST       		),
		.A_ARCACHE         			(M0_ARCACHE       		),
		.A_ARPROT          			(M0_ARPROT        		),
		.A_ARVALID         			(M0_ARVALID       		),
		.A_ARREADY         			(M0_ARREADY       		),
		.A_RDATA           			(M0_RDATA         		),
		.A_RRESP           			(M0_RRESP         		),
		.A_RLAST           			(M0_RLAST         		),
		.A_RVALID          			(M0_RVALID        		),
		.A_RREADY          			(M0_RREADY        		),
		.B_AWADDR          			(M1_AWADDR        		),
		.B_AWLEN           			(M1_AWLEN         		),
		.B_AWSIZE          			(M1_AWSIZE        		),
		.B_AWBURST         			(M1_AWBURST       		),
		.B_AWCACHE         			(M1_AWCACHE       		),
		.B_AWPROT          			(M1_AWPROT        		),
		.B_AWVALID         			(M1_AWVALID       		),
		.B_AWREADY         			(M1_AWREADY       		),
		.B_WDATA           			(M1_WDATA         		),
		.B_WSTRB           			(M1_WSTRB         		),
		.B_WLAST           			(M1_WLAST         		),
		.B_WVALID          			(M1_WVALID        		),
		.B_WREADY          			(M1_WREADY        		),
		.B_BRESP           			(M1_BRESP         		),
		.B_BVALID          			(M1_BVALID        		),
		.B_BREADY          			(M1_BREADY        		),
		.B_ARADDR          			(M1_ARADDR        		),
		.B_ARLEN           			(M1_ARLEN         		),
		.B_ARSIZE          			(M1_ARSIZE        		),
		.B_ARBURST         			(M1_ARBURST       		),
		.B_ARCACHE         			(M1_ARCACHE       		),
		.B_ARPROT          			(M1_ARPROT        		),
		.B_ARVALID         			(M1_ARVALID       		),
		.B_ARREADY         			(M1_ARREADY       		),
		.B_RDATA           			(M1_RDATA         		),
		.B_RRESP           			(M1_RRESP         		),
		.B_RLAST           			(M1_RLAST         		),
		.B_RVALID          			(M1_RVALID        		),
		.B_RREADY          			(M1_RREADY        		),
		
		.start       				(start     				),
		.addr_in					(addr_in				),
		.addr_out					(addr_out				),
		.count						(count					)
	);

endmodule
