`include "definitions.v"

`timescale 1ns / 1ps

// state definitions
`define STATE_POWERON_INIT_0 	0
`define STATE_POWERON_INIT_1 	1
`define STATE_POWERON_INIT_2 	2
`define STATE_POWERON_INIT_3 	3
`define STATE_POWERON_INIT_4 	4
`define STATE_POWERON_INIT_5 	5
`define STATE_POWERON_INIT_6 	6
`define STATE_POWERON_INIT_7 	7
`define STATE_POWERON_INIT_8 	8
`define STATE_POWERON_INIT_9 	9	
`define STATE_FSET				10
`define STATE_ENTRY_MOD			11
`define STATE_DISP_CTL			12
`define STATE_DISP_CLEAR		13
`define STATE_AFTER_CLEAR		14
`define STATE_WRITE_CHAR		15
`define STATE_RESET				16
`define STATE_WRITE_WAIT	   17

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:35:55 09/21/2016 
// Design Name: 
// Module Name:    LCD 
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

module LCD(
    input wire 	Clock,
    input wire 	Reset,
    output reg 	oLCD_Enabled,
    output reg 	oLCD_RegisterSelect,
    output wire 	oLCD_StrataFlashControl,
    output wire 	oLCD_ReadWrite,
    output reg 	[3:0] oLCD_Data
    );

assign oLCD_ReadWrite = 0; // only write mode is needed
assign oLCD_StrataFlashControl = 1; //StrataFlash disabled. Full read/write access to LCD

reg [7:0] rCurrentState,rNextState;
reg [31:0] rTimeCount;
reg rTimeCountReset;


reg wWriteBegin;			
reg [7:0] w8Bitsdata;
wire wWriteDone;
wire [3:0] oSender;
wire wLCD_EN;

   parameter LENGTH  = 2;
   wire [0:(8*LENGTH-1)] Chars;
   //assign Chars = {`H,`O,`L,`A,`SPC,`M,`U,`N,`D,`O}; 
	assign Chars = {`M,`U}; 
	integer i;

//sends one command/data when wWriteBegin=1
senderLCD senderCmds(
.iWriteBegin(wWriteBegin),
.iData(w8Bitsdata),
.Reset(Reset),
.Clock(Clock),
.oWriteDone(wWriteDone),
.oSender(oSender),
.oLCD_EN(wLCD_EN)
);

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
				rTimeCount <= 32'b0; // resets count
		else
				rTimeCount <= rTimeCount + 32'b1; // increments count
			
		rCurrentState <= rNextState;
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
		oLCD_Data = 				4'h0;
		oLCD_RegisterSelect = 	1'b0;
		rTimeCountReset = 		1'b1;
		oLCD_Enabled = 			1'b0;
		wWriteBegin = 				1'b0;
		w8Bitsdata = 				8'h0;
		rNextState = 				`STATE_POWERON_INIT_0;
		i = 0;
	end
	//------------------------------------------
	//The 15 ms interval is 750,000 clock cycles at 50 MHz.
	`STATE_POWERON_INIT_0: 
	begin
		oLCD_Data=					4'h0;
		oLCD_RegisterSelect=		1'b0; 
		rTimeCountReset=			1'b0;
		oLCD_Enabled = 			1'b0;
		wWriteBegin = 				1'b0;
		w8Bitsdata = 				8'h0;
		//delay 15ms
		if (rTimeCount > 32'd750000 ) 
		begin
			rTimeCountReset=1'b1; // resets count
			rNextState = `STATE_POWERON_INIT_1;
		end
		else
			rNextState = `STATE_POWERON_INIT_0;
	end
	//------------------------------------------
	//Write SF_D<11:8> = 0x3, pulse LCD_E High for 15 clock cycles
	`STATE_POWERON_INIT_1:
	begin
		oLCD_Data = 				4'h3;
		oLCD_RegisterSelect = 	1'b0; //these are commands
		rTimeCountReset = 		1'b0;
		oLCD_Enabled = 			1'b1; //E=1
		wWriteBegin = 				1'b0;
		w8Bitsdata = 				8'h0;
		
		if (rTimeCount > 32'd15 ) 
		begin
			rTimeCountReset=1'b1; // resets count
			rNextState = `STATE_POWERON_INIT_2;
		end
		else
			rNextState = `STATE_POWERON_INIT_1;
	end
	//------------------------------------------
	//The 4.1 ms interval is 205,000 clock cycles at 50 MHz.
	`STATE_POWERON_INIT_2:
	begin
		oLCD_Data = 				4'h0;
		oLCD_RegisterSelect = 	1'b0; 
		rTimeCountReset = 		1'b0;
		oLCD_Enabled = 			1'b0;
		wWriteBegin = 				1'b0;
		w8Bitsdata = 				8'h0;
		// delay 4.1ms
		if ( rTimeCount > 32'd205000 )
		begin
			rTimeCountReset=1'b1;// resets count
			rNextState = `STATE_POWERON_INIT_3;
		end
		else
			rNextState = `STATE_POWERON_INIT_2;
	end
		//------------------------------------------
		//4-bit write = 3 hex for 15 cycles
	`STATE_POWERON_INIT_3:
	begin
		oLCD_Data = 				4'h3; //0x3
		oLCD_RegisterSelect = 	1'b0; //these are commands
		rTimeCountReset = 		1'b0;
		oLCD_Enabled = 			1'b1; //E=1
		wWriteBegin = 				1'b0;
		w8Bitsdata = 				8'h0;
		
		if (rTimeCount > 32'd15 ) 
		begin
			rTimeCountReset=1'b1; // resets count
			rNextState = `STATE_POWERON_INIT_4;
		end
		else
			rNextState = `STATE_POWERON_INIT_3;
	end
	//------------------------------------------
	//The 100 us interval is 5,000 clock cycles at 50 MHz
	`STATE_POWERON_INIT_4:
	begin
		oLCD_Data = 				4'h0;
		oLCD_RegisterSelect = 	1'b0; 
		rTimeCountReset = 		1'b0;
		oLCD_Enabled = 			1'b0;
		wWriteBegin = 				1'b0;
		w8Bitsdata = 				8'h0;
		// delay 100us
		if ( rTimeCount > 32'd5000 )
		begin
			rTimeCountReset=1'b1; // resets count
			rNextState = `STATE_POWERON_INIT_5;
		end
		else
			rNextState = `STATE_POWERON_INIT_4;
	end
	//------------------------------------------
	//4-bit write = 3 hex for 15 cycles
	`STATE_POWERON_INIT_5:
	begin
		oLCD_Data = 				4'h3; //0x3
		oLCD_RegisterSelect = 	1'b0; //these are commands
		rTimeCountReset = 		1'b0;
		oLCD_Enabled = 			1'b1; //E=1
		wWriteBegin = 				1'b0;
		w8Bitsdata = 				8'h0;
		
		if (rTimeCount > 32'd15 )
		begin
			rTimeCountReset=1'b1; // resets count
			rNextState = `STATE_POWERON_INIT_6;
		end
		else
			rNextState = `STATE_POWERON_INIT_5;
	end
	//------------------------------------------
	//The 40 us interval is 2,000 clock cycles at 50 MHz
	`STATE_POWERON_INIT_6:
	begin
		oLCD_Data = 				4'h0;
		oLCD_RegisterSelect = 	1'b0; 
		rTimeCountReset = 		1'b0;
		oLCD_Enabled = 			1'b0;
		wWriteBegin = 				1'b0;
		w8Bitsdata = 				8'h0;
		// delay 40us
		if ( rTimeCount > 32'd2000 )
		begin
			rTimeCountReset = 1'b1; // resets count
			rNextState = `STATE_POWERON_INIT_7;
		end
		else
			rNextState = `STATE_POWERON_INIT_6;
	end
	//------------------------------------------
	//4-bit write = 2 hex for 15 cycles
	`STATE_POWERON_INIT_7:
	begin
		oLCD_Data = 				4'h2; //0x2
		oLCD_RegisterSelect = 	1'b0; //these are commands
		rTimeCountReset = 		1'b0;
		oLCD_Enabled = 			1'b1; //E=1
		wWriteBegin = 				1'b0;
		w8Bitsdata = 				8'h0;
		if (rTimeCount > 32'd15 )
		begin
			rTimeCountReset=1'b1; //resets count
			rNextState = `STATE_POWERON_INIT_8;
		end
		else
			rNextState = `STATE_POWERON_INIT_7;
	end
	//------------------------------------------
	//The 40 us interval is 2,000 clock cycles at 50 MHz
	`STATE_POWERON_INIT_8:
	begin
		oLCD_Data = 				4'h0;
		oLCD_RegisterSelect = 	1'b0; 
		rTimeCountReset = 		1'b0;
		oLCD_Enabled = 			1'b0;
		wWriteBegin = 				1'b0;
		w8Bitsdata = 				8'h0;
		//delay 40us
		if ( rTimeCount > 32'd2000 )
		begin
			rTimeCountReset=1'b1; //resets count
			rNextState = `STATE_FSET;
		end
		else
			rNextState = `STATE_POWERON_INIT_8;
	end
	//------------------------------------------
	// Issue a Function Set command, 0x28
	`STATE_FSET:
	begin
		oLCD_Data = 				oSender; //out of command sender
		oLCD_RegisterSelect = 	1'b0; 	//these are commands
		rTimeCountReset = 		1'b1;
		oLCD_Enabled = 			wLCD_EN;
		wWriteBegin = 				1'b1; 	
		w8Bitsdata = 				8'h28;	//command
		
		if ( wWriteDone )// waits signal from command sender
		begin 
			rNextState = `STATE_ENTRY_MOD;
		end
		else
			rNextState = `STATE_FSET;
	end
	//------------------------------------------
	//Issue an Entry Mode Set command, 0x06
	`STATE_ENTRY_MOD:
	begin
		oLCD_Data = 				oSender; //out of command sender
		oLCD_RegisterSelect = 	1'b0; 	//these are commands
		rTimeCountReset = 		1'b1;
		oLCD_Enabled = 			wLCD_EN;
		wWriteBegin = 				1'b1;
		w8Bitsdata = 				8'h07;	//command
		
		if ( wWriteDone )// waits signal from command sender
		begin
			rNextState = `STATE_DISP_CTL;
		end
		else
			rNextState = `STATE_ENTRY_MOD;
	end
	//------------------------------------------
	//Issue a Display command, 0x0C
	`STATE_DISP_CTL:
	begin
		oLCD_Data = 				oSender; //out of command sender
		oLCD_RegisterSelect = 	1'b0; 	//these are commands
		rTimeCountReset = 		1'b1;
		oLCD_Enabled = 			wLCD_EN;
		wWriteBegin = 				1'b1;
		w8Bitsdata = 				8'h0C; 	//command
		
		if ( wWriteDone )// waits signal from command sender
		begin
			rNextState = `STATE_DISP_CLEAR;
		end
		else
			rNextState = `STATE_DISP_CTL;
	end
	
	//------------------------------------------
	//Issue a Clear Display command, 0x01
	`STATE_DISP_CLEAR:
	begin
		oLCD_Data = 				oSender; //out of command sender
		oLCD_RegisterSelect = 	1'b0; 	//these are commands
		rTimeCountReset = 		1'b1;
		oLCD_Enabled = 			wLCD_EN;
		wWriteBegin = 				1'b1;
		w8Bitsdata = 				8'h01;	//command

		if ( wWriteDone )// waits signal from command sender
		begin
			rNextState = `STATE_AFTER_CLEAR;
		end
		else
			rNextState = `STATE_DISP_CLEAR;
	end

	//------------------------------------------
	//The 1.7 ms interval is 85,000 clock cycles at 50 MHz
	`STATE_AFTER_CLEAR:
	begin
		oLCD_Data = 				oSender;
		oLCD_RegisterSelect = 	1'b0; 
		rTimeCountReset =			1'b0;
		oLCD_Enabled = 			1'b0;
		wWriteBegin = 				1'b0;
		w8Bitsdata = 				8'h0;
		//delay 1.7ms
		if (rTimeCount > 32'd85000 )
		begin
			rTimeCountReset=1'b1;
			rNextState = `STATE_WRITE_CHAR;
		end
		else
			rNextState = `STATE_AFTER_CLEAR;
	end

	//------------------------------------------
	// write Z
	`STATE_WRITE_CHAR:
	begin
		oLCD_Data = 				oSender;
		oLCD_RegisterSelect = 	1'b1; 	//this is data
		rTimeCountReset =			1'b0;
		oLCD_Enabled = 			wLCD_EN;
		wWriteBegin = 				1'b1;
		
		//for(i=0; i<LENGTH; i=i+1)begin
			w8Bitsdata = Chars[i*8 +: 8];	//'Z'
			//w8Bitsdata = 8'h14;
		//end
		
		//w8Bitsdata = 				8'h30;	//'Z'
		if ( wWriteDone )// waits signal from command sender
		begin
			rNextState = `STATE_WRITE_WAIT;
			i = i+1;
		end
		else
			rNextState = `STATE_WRITE_CHAR;
	end
	
	//------------------------------------------
	// write Z
	`STATE_WRITE_WAIT:
	begin
		oLCD_Data = 				oSender;
		oLCD_RegisterSelect = 	1'b0; 	//this is data
		rTimeCountReset =			1'b0;
		oLCD_Enabled = 			wLCD_EN;
		wWriteBegin = 				1'b1;
		//for(i=0; i<LENGTH; i=i+1)begin
			//w8Bitsdata = Chars[i*8 +: 8];	//'Z'
			w8Bitsdata = 8'h14;
		//end
		
		//w8Bitsdata = 				8'h30;	//'Z'
		if ( i>=LENGTH)// waits signal from command sender
		begin
			rNextState = `STATE_WRITE_WAIT;
		end
		else
			rNextState = `STATE_WRITE_CHAR;
	end
	//------------------------------------------
	default:
	begin
		oLCD_Data=					4'h0;
		oLCD_RegisterSelect=		1'b0; 
		rTimeCountReset=			1'b0;
		oLCD_Enabled = 			1'b0;
		wWriteBegin = 				1'b0;
		w8Bitsdata = 				8'h0;		
		rNextState = `STATE_RESET;
	end
	//------------------------------------------
	endcase
end
endmodule
