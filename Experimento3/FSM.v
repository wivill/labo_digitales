`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    07:48:57 05/03/2017
// Design Name:
// Module Name:    FSM
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

`define STATE_RESET 				 0
`define STATE_WAIT_15 			 1
`define STATE_TIMER_RESET 		 2
`define STATE_POWERON_INIT_1   3
`define STATE_POWERON_INIT_2   4
`define STATE_WAIT_2   			 5
`define STATE_FUNCTION_SET 	 6
`define STATE_ENTRY_MODE   	 7
`define STATE_DISPLAY_CONTROL  8
`define STATE_DISPLAY_CLEAR    9


module Module_LCD_Control
(
input wire Clock,
input wire Reset,
output wire oLCD_Enabled,
output reg oLCD_RegisterSelect, //0=Command, 1=Data
output wire oLCD_StrataFlashControl,
output wire oLCD_ReadWrite,
output reg[3:0] oLCD_Data
);

reg rWrite_Enabled;
assign oLCD_ReadWrite = 0;  //I Write to the LCD display, never Read from it
assign oLCD_StrataFlashControl = 1; //StrataFlash disabled. Full read/write access to LCD
reg [7:0] rCurrentState,rNextState;
reg [31:0] rTimeCount;
reg rTimeCountReset;
wire wWriteDone;
//----------------------------------------------
//Variables nuevas:
reg [2:0] prox_wait_state = 0;
//--------------------------------------------

//Next State and delay logic
always @ ( posedge Clock )
begin
	if (Reset) begin
		rCurrentState <= `STATE_RESET;
		rTimeCount <= 32'b0;
	end else begin
		if (rTimeCountReset) begin
			rTimeCount <= 32'b0;
		end else begin
			rTimeCount <= rTimeCount + 32'b1;
			rCurrentState <= rNextState;
		end
	end
end

//----------------------------------------------
//Current state and output logic

always @ ( * )
begin
	case (rCurrentState)
//------------------------------------------
	`STATE_RESET:
	begin
		rWrite_Enabled = 1'b0;
		oLCD_Data = 4'h0;
		oLCD_RegisterSelect = 1'b0;
		rTimeCountReset = 1'b0;

		rNextState = `STATE_WAIT_15;
	end
//------------------------------------------
/*
Wait 15 ms or longer.
The 15 ms interval is 750,000 clock cycles at 50 MHz.
*/

	`STATE_WAIT_15:
	begin
		rWrite_Enabled = 1'b0;
		oLCD_Data = 4'h0;
		oLCD_RegisterSelect = 1'b0; //these are commands
		rTimeCountReset = 1'b0;

		if (rTimeCount > 32'd750000 ) begin
			prox_wait_state = prox_wait_state + 1;
			rNextState = `STATE_TIMER_RESET;
		end else begin
			rNextState = `STATE_WAIT_15;
		end
	end
//------------------------------------------

	`STATE_TIMER_RESET:
	begin
		rWrite_Enabled = 1'b0;
		oLCD_Data = 4'h0;
		oLCD_RegisterSelect = 1'b0; //these are commands
		rTimeCountReset = 1'b1; //Reset the counter here
		if(prox_wait_state == 1)
		begin
			rNextState = `STATE_POWERON_INIT_1;
		end

		case(prox_wait_state)
		1:
		begin
			rNextState = `STATE_POWERON_INIT_1;
		end
		2:
		begin
			rNextState = `STATE_POWERON_INIT_1;
		end
		3:
		begin
			rNextState = `STATE_POWERON_INIT_1;
		end
		4:
		begin
			rNextState = `STATE_POWERON_INIT_2;
		end
		5:
		begin
			rNextState = `STATE_FUNCTION_SET;
		end
		default:
		begin
			rNextState = `STATE_FUNCTION_SET;
		end
		endcase
	end

//------------------------------------------
	`STATE_POWERON_INIT_1:
	begin
		rWrite_Enabled = 1'b1;
		oLCD_Data = 4'h3;
		oLCD_RegisterSelect = 1'b0; //these are commands
		rTimeCountReset = 1'b1;

		if ( wWriteDone )
			rNextState = `STATE_WAIT_15;
		else
			rNextState = `STATE_POWERON_INIT_1;
	end
//------------------------------------------
/*
Wait 4.1 ms or longer, which is 205,000 clock cycles at 50 MHz.
*/

	`STATE_WAIT_2:
	begin
		rWrite_Enabled = 1'b0;
		oLCD_Data = 4'h3;
		oLCD_RegisterSelect = 1'b0; //these are commands
		rTimeCountReset = 1'b0;

		if (rTimeCount > 32'd102500 )
			rNextState = `STATE_FUNCTION_SET;
		else
			rNextState = `STATE_WAIT_2;
	end
//------------------------------------------

	`STATE_POWERON_INIT_2:
	begin
		rWrite_Enabled = 1'b1;
		oLCD_Data = 4'h2;
		oLCD_RegisterSelect = 1'b0; //these are commands
		rTimeCountReset = 1'b1;

		if ( wWriteDone )
			rNextState = `STATE_WAIT_15;
		else
			rNextState = `STATE_POWERON_INIT_2;
	end
//------------------------------------------

	`STATE_FUNCTION_SET:
	begin
		rWrite_Enabled = 1'b1;
		oLCD_Data = 4'b0001; // 2
		// delay
		oLCD_Data = 4'b1100; // 8
		oLCD_RegisterSelect = 1'b0; //these are commands
		rTimeCountReset = 1'b1;

		if ( wWriteDone )
			rNextState = `STATE_ENTRY_MODE;
		else
			rNextState = `STATE_FUNCTION_SET;
	end

//------------------------------------------

	`STATE_ENTRY_MODE:
	begin
		rWrite_Enabled = 1'b1;
		oLCD_Data = 4'h06;
		oLCD_RegisterSelect = 1'b0; //these are commands
		rTimeCountReset = 1'b1;

		if ( wWriteDone )
			rNextState = `STATE_DISPLAY_CONTROL;
		else
			rNextState = `STATE_ENTRY_MODE;
	end

//------------------------------------------

	`STATE_DISPLAY_CONTROL:
	begin
		rWrite_Enabled = 1'b1;
		oLCD_Data = 4'h0F;
		oLCD_RegisterSelect = 1'b0; //these are commands
		rTimeCountReset = 1'b1;

		if ( wWriteDone )
			rNextState = `STATE_DISPLAY_CLEAR;
		else
			rNextState = `STATE_DISPLAY_CONTROL;
	end

//------------------------------------------

	`STATE_DISPLAY_CLEAR:
	begin
		rWrite_Enabled = 1'b1;
		oLCD_Data = 4'h01;
		oLCD_RegisterSelect = 1'b0; //these are commands
		rTimeCountReset = 1'b1;

		if ( wWriteDone )
			rNextState = `STATE_DISPLAY_CLEAR;
		else
			rNextState = `STATE_DISPLAY_CONTROL;
	end

//------------------------------------------

	default:
	begin
		rWrite_Enabled = 1'b0;
		oLCD_Data = 4'h0;
		oLCD_RegisterSelect = 1'b0;
		rTimeCountReset = 1'b0;

		rNextState = `STATE_RESET;
	end

//------------------------------------------
	endcase
	end

endmodule
