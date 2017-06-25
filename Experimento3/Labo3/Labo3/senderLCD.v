`timescale 1ns / 1ps

//state definitions
`define STATE_RESET 			0
`define STATE_BEFORE_EN_H 	1
`define STATE_HOLD_EN_H 	2
`define STATE_AFTER_EN_H 	3
`define STATE_INTER 			4
`define STATE_BEFORE_EN_L 	5
`define STATE_HOLD_EN_L 	6
`define STATE_AFTER_EN_L 	7
`define STATE_FINISH_W 		8

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:56:50 09/21/2016 
// Design Name: 
// Module Name:    senderLCD 
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

module senderLCD(
	input wire iWriteBegin,
	input wire [7:0] iData,
	input wire Reset,
	input wire Clock,
	output reg oWriteDone,
	output reg [3:0] oSender,
	output reg oLCD_EN
   );

reg [7:0] rCurrentState,rNextState;
reg rTimeCountReset;
reg [31:0] rTimeCount;

//----------------------------------------------
//Next State and delay logic
always @ ( posedge Clock )
begin
	if (Reset)
	begin
		rCurrentState <= `STATE_RESET;
		rTimeCount <= 32'b0;
	end
	else
	begin
		if (rTimeCountReset)
				rTimeCount <= 32'b0; //restart count
		else
				rTimeCount <= rTimeCount + 32'b1; //increments count
			
		rCurrentState <= rNextState;
	end
end

//----------------------------------------------
//Current state and output logic
always @ ( * )
begin
	case (rCurrentState)
	//-----------------------------------------
	//reset state
	`STATE_RESET:
	begin
		oSender = 			4'b0;
		oWriteDone = 		1'b0;
		oLCD_EN = 			1'b0;
		rTimeCountReset = 1'b1;
		
		if(iWriteBegin)
			rNextState = `STATE_BEFORE_EN_H;
		else
			rNextState = `STATE_RESET;
	end
	//------------------------------------------
	//set 4 upper bits data to send, E=0
	`STATE_BEFORE_EN_H:
	begin
		oSender = 			iData[7:4]; //upper bits
		oWriteDone = 		'b0;
		oLCD_EN = 			1'b0;			//E=0
		rTimeCountReset = 1'b0;
		
		//delay 40ns
		if (rTimeCount > 32'd2 )
		begin
			rTimeCountReset = 1'b1; //resets count
			rNextState = `STATE_HOLD_EN_H;
		end
		else
			rNextState = `STATE_BEFORE_EN_H;
	end
	//------------------------------------------
	//hold the upper 4 bits data and E=1
	`STATE_HOLD_EN_H:
	begin
		oSender = 			iData[7:4]; //upper bits
		oWriteDone = 		1'b0;
		oLCD_EN = 			1'b1;			//E=1
		rTimeCountReset = 1'b0;
		
		//delay 240 ns
		if (rTimeCount > 32'd12 )
		begin
			rTimeCountReset = 1'b1; //resets count
			rNextState = `STATE_AFTER_EN_H;
		end
		else
			rNextState = `STATE_HOLD_EN_H;
	end
	//------------------------------------------
	//clear E, hold upper bits for 40ns
	`STATE_AFTER_EN_H:
	begin
		oSender = 			iData[7:4]; //upper bits
		oWriteDone = 		1'b0;
		oLCD_EN = 			1'b0;			//E=0
		rTimeCountReset = 1'b0;
		
		//delay 40ns
		if (rTimeCount > 32'd2 )
		begin
			rTimeCountReset = 1'b1; //resets count
			rNextState = `STATE_INTER;
		end
		else
			rNextState = `STATE_AFTER_EN_H;
	end
	
	//------------------------------------------
	//delay between 4 bit sending events
	`STATE_INTER:
	begin
		oSender = 			4'b0;
		oWriteDone = 		1'b0;
		oLCD_EN = 			1'b0;
		rTimeCountReset = 1'b0;
		
		//delay 1us
		if (rTimeCount > 32'd50 )
		begin
			rTimeCountReset = 1'b1; //resets count
			rNextState = `STATE_BEFORE_EN_L;
		end
		else
			rNextState = `STATE_INTER;
	end

	//------------------------------------------
	//set 4 lower bits data to send, E=0
	`STATE_BEFORE_EN_L:
	begin
		oSender = 			iData[3:0]; //lower bits
		oWriteDone = 		1'b0;
		oLCD_EN = 			1'b0;			//E=0
		rTimeCountReset = 1'b0;
		
		//delay 40ns
		if (rTimeCount > 32'd2 )
		begin
			rTimeCountReset = 1'b1; //resets count
			rNextState = `STATE_HOLD_EN_L;
		end
		else
			rNextState = `STATE_BEFORE_EN_L;
	end
	//------------------------------------------
	//hold the lower 4 bits data and E=1
	`STATE_HOLD_EN_L:
	begin
		oSender = 			iData[3:0]; //lower bits
		oWriteDone = 		1'b0;
		oLCD_EN = 			1'b1;			//E=1
		rTimeCountReset = 1'b0;
		
		//delay 240ns
		if (rTimeCount > 32'd12 )
		begin
			rTimeCountReset=1'b1; //resets count
			rNextState = `STATE_AFTER_EN_L;
		end
		else
			rNextState = `STATE_HOLD_EN_L;
	end
	//------------------------------------------
	//clear E, hold lower bits for 40ns
	`STATE_AFTER_EN_L:
	begin
		oSender = 			iData[3:0]; //lower bits
		oWriteDone = 		1'b0;
		oLCD_EN = 			1'b0;			//E=0
		rTimeCountReset = 1'b0;
		
		//delay 40ns
		if (rTimeCount > 32'd2 )
		begin
			rTimeCountReset = 1'b1; //resets count
			rNextState = `STATE_FINISH_W;
		end
		else
			rNextState = `STATE_AFTER_EN_L;
	end
	
	//------------------------------------------
	//delay of 40us between commands/data
	`STATE_FINISH_W:
	begin
		oSender = 			4'b0;
		oWriteDone = 		1'b0;
		oLCD_EN = 			1'b0;
		rTimeCountReset = 1'b0;
		
		//delay 40us
		if (rTimeCount > 32'd2000 )
		begin
			rTimeCountReset = 1'b1;
			oWriteDone = 		1'b1;				//sets end signal
			rNextState = 		`STATE_RESET;
		end
		else
			rNextState = 		`STATE_FINISH_W;
	end
	
	//------------------------------------------
	default:
	begin
		oSender = 			4'b0;
		oWriteDone = 		1'b0;
		oLCD_EN = 			1'b0;
		rTimeCountReset = 1'b0;
		rNextState = 		`STATE_RESET;
	end
	
	endcase
end
endmodule
