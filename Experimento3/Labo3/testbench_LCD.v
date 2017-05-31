`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:29:01 09/21/2016
// Design Name:   LCD
// Module Name:   testbench_LCD.v
// Project Name:  Experimento3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: LCD
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench_LCD;

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
	LCD lcd (
		.Clock(Clock), 
		.Reset(Reset), 
		.oLCD_Enabled(oLCD_Enabled),
		.oLCD_RegisterSelect(oLCD_RegisterSelect),
		.oLCD_StrataFlashControl(oLCD_StrataFlashControl),
		.oLCD_ReadWrite(oLCD_ReadWrite),
		.oLCD_Data(oLCD_Data)
	);
	
	always #10 Clock = !Clock;

	initial begin 
		// Initialize Inputs
		Clock = 0;
		Reset = 0;
		
		// reset module
		#50
		Reset = 1;
		#50
		Reset = 0;
		
		// Wait 22 ms 
		#22000000;
		
		#22000000;
		
		#22000000;
		
		$finish;
	end
      
endmodule
