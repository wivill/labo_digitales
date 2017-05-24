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
	wire oLCD_Enabled;
	wire oLCD_RegisterSelect;
	wire oLCD_StrataFlashControl;
	wire oLCD_ReadWrite;
	wire [3:0] oLCD_Data;
	
	// Instantiate the Unit Under Test (UUT)
	LCD uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.oLCD_Enabled(oLCD_Enabled), 
		.oLCD_RegisterSelect(oLCD_RegisterSelect), 
		.oLCD_StrataFlashControl(oLCD_StrataFlashControl), 
		.oLCD_ReadWrite(oLCD_ReadWrite), 
		.oLCD_Data(oLCD_Data)
	);
	
	// generates clock signal
	always #10 Clock = !Clock;

	initial begin 
		// Initialize Inputs
		Clock = 0;
		Reset = 0;
		
		// reset module
		#100
		Reset = 1;
		#100
		Reset = 0;
		
		// Wait 22 ms 
		#22000000
		
		$finish;
	end
      
endmodule
