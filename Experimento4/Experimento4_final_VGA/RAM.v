`timescale 1ns / 1ps

module RAM_DUAL_READ_PORT # ( parameter DATA_WIDTH= 16, parameter ADDR_WIDTH=8, parameter MEM_SIZE=8 )
   (
    input wire 			Clock,
    input wire 			iWriteEnable,
    input wire [ADDR_WIDTH-1:0] iReadAddress0,
    input wire [ADDR_WIDTH-1:0] iReadAddress1,
    input wire [ADDR_WIDTH-1:0] iWriteAddress,
    input wire [DATA_WIDTH-1:0] iDataIn,
    output reg [DATA_WIDTH-1:0] oDataOut0,
    output reg [DATA_WIDTH-1:0] oDataOut1
    );

   reg [DATA_WIDTH-1:0] 	Ram [MEM_SIZE:0];		

   always @(posedge Clock) 
      begin 
	 
	 if (iWriteEnable) 
	    Ram[iWriteAddress] <= iDataIn; 
	 	 
	 oDataOut0 <= Ram[iReadAddress0]; 
	 oDataOut1 <= Ram[iReadAddress1]; 
      end 
endmodule

module RAM_SINGLE_READ_PORT # ( parameter DATA_WIDTH= 16, 
				parameter ADDR_WIDTH=8, 
				parameter MEM_SIZE=8, 
				parameter MEM_INIT=0) 
   ( 
     input wire 		 Clock, 
     input wire 		 iWriteEnable, 
     input wire [ADDR_WIDTH-1:0] iReadAddress, 
     input wire [ADDR_WIDTH-1:0] iWriteAddress, 
     input wire [DATA_WIDTH-1:0] iDataIn, 
     output reg [DATA_WIDTH-1:0] oDataOut
     );
   
   reg [DATA_WIDTH-1:0] 	 Ram [MEM_SIZE:0]; 

   integer 				 i;
   
   // initial 
   //    begin
   // 	 for (i = 0; i < MEM_SIZE; i=i+1) Ram[i] = MEM_INIT; 
   //    end
   
   always @(posedge Clock) 
      begin 
	 if (iWriteEnable) 
	    Ram[iWriteAddress] <= iDataIn; 

	 oDataOut <= Ram[iReadAddress]; 
      end 

endmodule

module RAM_SINGLE_READ_PORT_2D # ( parameter DATA_WIDTH=4,
				   parameter ADDR_WIDTH_X=8,
				   parameter ADDR_WIDTH_Y=8, 
				   parameter MEM_SIZE_X=256,
				   parameter MEM_SIZE_Y=256
				   )
   (
    input wire 			  Clock, 
    input wire 			  iWriteEnable, 
    input wire [ADDR_WIDTH_X-1:0] iReadAddressX,
    input wire [ADDR_WIDTH_Y-1:0] iReadAddressY,
    input wire [ADDR_WIDTH_X-1:0] iWriteAddressX,
    input wire [ADDR_WIDTH_Y-1:0] iWriteAddressY,
    input wire [DATA_WIDTH-1:0]   iDataIn, 
    output reg [DATA_WIDTH-1:0]   oDataOut
    );

   reg [DATA_WIDTH-1:0] Ram [MEM_SIZE_Y-1:0][MEM_SIZE_X-1:0];

   always @(posedge Clock)
      begin
	 if (iWriteEnable)
	    Ram[iWriteAddressY][iWriteAddressX] <= iDataIn;

	 oDataOut <= Ram[iReadAddressY][iReadAddressX];
      end

endmodule
