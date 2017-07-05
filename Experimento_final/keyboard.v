`timescale 1ns / 1ps
`include "Definitions.v"
//----------------------------------------------------------------------
// Módulo keyboard para controlar el PS/2
module keyboard
(
	input wire Reset,
	input wire PS2_CLK,
	input wire PS2_DATA,
	output reg [7:0] XRedCounter,
	output reg [7:0] YRedCounter,
	output reg [2:0] ColorReg
);
//------------------------------------------------------------------------
//------------------------------------------------------------------------
reg [7:0] ScanCode;
reg [8:0] rDataBuffer;
reg Done, Read;
reg [3:0] ClockCounter;
reg rFlagF0, rFlagNoError;
//------------------------------------------------------------------------
//------------------------------------------------------------------------
always @ (negedge PS2_CLK or posedge Reset) begin
	if (Reset) begin

		ClockCounter <= 0;
		Read <= 1;
		Done <= 0;
		end

	else begin
		if (Read == 1'b1 && PS2_DATA == 1'b0) begin

			Read <= 0;
			Done <= 0;
			end

		else if (Read == 1'b0) begin
			if (ClockCounter < 9) begin

				ClockCounter <= ClockCounter + 1;
				rDataBuffer <= {PS2_DATA, rDataBuffer[8:1]};
				Done <= 0;
				end

			else begin

				ClockCounter <= 1'b0;
				Done <= 1;
				ScanCode <= rDataBuffer[7:0];
				Read <= 1;

				if (ScanCode == rDataBuffer[8])

					rFlagNoError <= 1'b0;

				else

					rFlagNoError <= 1'b1;

				end

		end
	end
end
//------------------------------------------------------------------------
//------------------------------------------------------------------------
always @ (posedge Done or posedge Reset) begin
	if (Reset) begin

		XRedCounter <= 8'b0;
		YRedCounter <= 8'b0;
		rFlagF0 <= 1'b0;
		ColorReg <= 3'b1;
		end

	else begin
		if (rFlagF0) begin

			rFlagF0 <= 1'b0;

		end
		else
		//------------------------------------------------------------------------
		case (ScanCode)
			`W: begin
				YRedCounter <= YRedCounter - 8'd32;
				XRedCounter <= XRedCounter;
				rFlagF0 <= rFlagF0;
				ColorReg <= ColorReg;
			end
//------------------------------------------------------------------------
			`S: begin
				YRedCounter <= YRedCounter + 8'd32;
				XRedCounter <= XRedCounter;
				rFlagF0 <= rFlagF0;
				ColorReg <= ColorReg;
			end
//------------------------------------------------------------------------
			`A: begin
				YRedCounter <= YRedCounter;
				XRedCounter <= XRedCounter - 8'd32;
				rFlagF0 <= rFlagF0;
				ColorReg <= ColorReg;
			end
//------------------------------------------------------------------------
			`D: begin
				YRedCounter <= YRedCounter;
				XRedCounter <= XRedCounter + 8'd32;
				rFlagF0 <= rFlagF0;
				ColorReg <= ColorReg;
			end
//------------------------------------------------------------------------
			8'hF0: begin	//Señal de finalizacion del PS2
				YRedCounter <= YRedCounter;
				XRedCounter <= XRedCounter;
				rFlagF0 <= 1'b1;
				ColorReg <= ColorReg;
			end
//------------------------------------------------------------------------
			8'h29: begin	//29 = Barra Espaciadora
				ColorReg <= ColorReg + 3'b1;
				YRedCounter <= YRedCounter;
				XRedCounter <= XRedCounter;
				rFlagF0 <= rFlagF0;
			end

			default: begin
				YRedCounter <= YRedCounter;
				XRedCounter <= XRedCounter;
				rFlagF0 <= rFlagF0;
				ColorReg <= ColorReg;
			end
		endcase
	end
end

endmodule
