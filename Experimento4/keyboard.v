`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    09:29:26 10/12/2016
// Design Name:
// Module Name:    keyboard
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

`define ST_check 				0
`define ST_do 					1
`define ST_error 				2
`define ST_check_par 		3
`define ST_doa					4
module keyboard(
	input wire iClock,
	input wire iData,
	input wire iReset,
	output wire [7:0] oLed,
	output reg [7:0] cmd_mov
);
	reg [8:0] oCode;
	reg [8:0] rTempCode;
	reg [3:0] index;
	reg reset_index;
	reg [7:0] rCurrentState,rNextState;
	reg parity_error;
	reg rResetCmdMov;
	assign oLed={5'b0,cmd_mov};

	always @ ( negedge iClock)
		begin
		if(iReset)
			begin
			rCurrentState = `ST_check;
			index = 4'b0;
			end
		else
			begin
			if (reset_index)
						index = 4'b0; //restart count
				else
						index = index + 4'b1; //increments count

			rCurrentState = rNextState;
			end

		case (rCurrentState)
		//-----------------------------------------
		// reset/check state
		`ST_check:
		begin
			reset_index=1;

			if(iData == 0)
				begin
				rNextState = `ST_do;
				end
			else
				begin
				rNextState = `ST_check;
				end
		end


		//------------------------------------------
		// fill oCode with the 11 bits
		`ST_do:
			begin
			reset_index=0;
			if (index == 9 )
				begin
				if (iData == 1)
					begin
					if(parity_error==1'b1)
						rNextState = `ST_check;
					else
						begin
						// ignores termination codes
						if(rResetCmdMov==1'b1)
							begin
							rResetCmdMov=1'b0;
							oCode = 9'b0;
							end
						else
							begin
							if(rTempCode[7:0]==8'hF0)
								begin
								rResetCmdMov = 1'b1; // reset flag FF cmd_mov
								end
							else
								oCode = rTempCode;
							end

						rNextState = `ST_check;
						end

					end
				else
					begin
					rNextState = `ST_check;
					end
				end
			else
				begin
				rTempCode[index]=iData;
				rNextState = `ST_do;
				end
			end

		//------------------------------------------
		default:
			begin
			rNextState = 			`ST_check;
			end

		endcase
	end // always *

	// checks parity
	always @(*) begin
	if (^rTempCode[7:0] == rTempCode[8])
		begin
		parity_error = 1'b1; // parity error detected
		end
	else
		begin
		parity_error = 1'b0;
		end
	end


	always @(*)
		begin

		cmd_mov=oCode[7:0];

		end

	// FF cmd_mov
endmodule //keyboard
