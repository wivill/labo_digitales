`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:20:14 09/28/2016 
// Design Name: 
// Module Name:    upcounter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module  upcounter
	#(parameter WIDTH=8)
	(
	input reset,
	input enable,
	input clock,
	output reg [WIDTH-1:0] oResult
    );
	
	always @(posedge clock)
	begin
		if(reset)
			oResult = 0; 
		else 
			if(enable)
				oResult = oResult + 1;
	end

endmodule
