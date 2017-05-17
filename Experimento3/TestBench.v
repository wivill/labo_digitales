`timescale 1ms / 1ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:30:52 01/30/2011
// Design Name:   MiniAlu
// Module Name:   D:/Proyecto/RTL/Dev/MiniALU/TestBench.v
// Project Name:  MiniALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MiniAlu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestBench;

	// Inputs
	reg Clock;
	reg Reset;

	// Outputs
	reg [7:0] oLed;
	wire oLCD_Enabled;
	wire oLCD_RegisterSelect; //0=Command, 1=Data
	reg oLCD_StrataFlashControl;
	reg oLCD_ReadWrite;
	wire[3:0] oLCD_Data;
	Module_LCD_Control uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.oLCD_Enabled(oLCD_Enabled),
		.oLCD_RegisterSelect(oLCD_RegisterSelect),
		.oLCD_StrataFlashControl(oLCD_StrataFlashControl),
		.oLCD_ReadWrite(oLCD_ReadWrite),
		.oLCD_Data(oLCD_Data)
	);
	
	always
	begin
		#10  Clock =  ! Clock;

	end

	initial begin
		// Initialize Inputs
		Clock = 0;
		Reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
		Reset = 1;
		#50
		Reset = 0;
      #100;
		// Add stimulus here

	end
      
endmodule

