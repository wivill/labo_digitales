`timescale 1ns / 1ps
`include "Definitions.v"
//------------------------------------------------
// Permite llevar el orden de ejecucin de instrucciones
module UPCOUNTER_POSEDGE # (parameter SIZE=16)
(
input wire Clock, Reset,
input wire [SIZE-1:0] Initial,
input wire Enable,
output reg [SIZE-1:0] Q
);


  always @(posedge Clock )
  begin
      if (Reset)
        Q = Initial;
      else
		begin
		if (Enable)
			Q = Q + 1;

		end
  end

endmodule
//----------------------------------------------------
module FFD_POSEDGE_SYNCRONOUS_RESET # ( parameter SIZE=8 )
(
	input wire				Clock,
	input wire				Reset,
	input wire				Enable,
	input wire [SIZE-1:0]	D,
	output reg [SIZE-1:0]	Q
);


always @ (posedge Clock)
begin
	if ( Reset )
		Q <= 0;
	else
	begin
		if (Enable)
			Q <= D;
	end

end//always

endmodule
//----------------------------------------------------------------------
// module MUX # ( parameter SIZE=16 )
// (
// 	input wire						Clock,
// 	input wire [SIZE-1:0]		in0,
// 	input wire [SIZE-1:0]		in1,
// 	input wire [SIZE-1:0]  		in2,
// 	input wire [SIZE-1:0]		in3,
// 	input wire [1:0]				select,
// 	output reg [SIZE-1:0]	   out
// );
//
// always @ (*)
// begin
// 		case(select)
// 			2'b00 :
// 				begin
// 					out <= in0;
// 				end
// 			2'b01 :
// 				begin
// 					out <= in1;
// 				end
// 			2'b10 :
// 				begin
// 					out <= in2;
// 				end
// 			2'b11 :
// 				begin
// 					out <= in3;
// 				end
// 			default :
// 				begin
// 					out <= 16'hCAFE;
// 				end
// 		endcase
//
// end//always
//
// endmodule
//----------------------------------------------------------------------

//Multiplicador ejercicio 2 y 3

//module MULTIPLICADOR3 # (parameter SIZE=16)
//(
//	input wire [SIZE-2:2] Ci,
//	input wire [SIZE-1:0] iA,
//	input wire [SIZE-1:0] iB,
//	output reg Co,
//	output reg [SIZE:0] Res
//);
//	assign Ci[0] = 1'b0;
//	assign Co = Ci[SIZE];
//
//	genvar i;
//	generate
//		for (i=1; i<SIZE-1, i=i+1)
//		begin: mult_cell
//			assign Res[0] = iA[0]&iB[0];
//			assign {Ci[i+1],Res[i]} = iA[i]&iB[0] + iA[i-1]&iB[1] + Ci[i];
//			assign {Ci[SIZE],Res[SIZE-1]} = iA[SIZE-1]&iB[1] + Ci[SIZE-1];
//		end
//	endgenerate
//
//
//
//endmodule

//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Mdulo keyboard para controlar el PS/2
/*module keyboard
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

				if (^ScanCode == rDataBuffer[8])

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
			8'hF0: begin	//Seal de finalizacion del PS2
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

endmodule*/

/*module VGA_controller
(
	input wire				slow_clock,
	input wire 				Reset,
	input wire	[2:0]		iVGA_RGB,
	input wire  [2:0]		iColorCuadro,
	input wire  [7:0]		iXRedCounter,
	input wire  [7:0]		iYRedCounter,
	output wire	[2:0]		oVGA_RGB,
	output wire				oHsync,
	output wire				oVsync,
	output wire [9:0]		oVcounter,
	output wire [9:0]		oHcounter
);
wire iVGA_R, iVGA_G, iVGA_B;
wire oVGA_R, oVGA_G, oVGA_B;
wire wEndline;
wire [3:0] wMarco; //, wCuadro;
wire [2:0] wVGAOutputSelection;

assign wMarco = 3'b0;
//assign wCuadro = 3'b100;
assign wVGAOutputSelection = ( ((oHcounter >= iXRedCounter + 10'd240) && (oHcounter <= iXRedCounter + 10'd240 + 10'd32)) &&
										 ((oVcounter >= iYRedCounter + 10'd141) && (oVcounter <= iYRedCounter + 10'd141 + 8'd32))) ?
										iColorCuadro : {iVGA_R, iVGA_G, iVGA_B};

assign iVGA_R = iVGA_RGB[2];
assign iVGA_G = iVGA_RGB[1];
assign iVGA_B = iVGA_RGB[0];
assign oVGA_RGB = {oVGA_R, oVGA_G, oVGA_B};

assign oHsync = (oHcounter < 704) ? 1'b1 : 1'b0;
assign wEndline = (oHcounter == 799);
assign oVsync = (oVcounter < 519) ? 1'b1 : 1'b0;

// Marco negro e imagen de 256*256
assign {oVGA_R, oVGA_G, oVGA_B} = (oVcounter < 141 || oVcounter >= 397 ||
					  oHcounter < 240 || oHcounter > 496) ?
					  wMarco : wVGAOutputSelection;

UPCOUNTER_POSEDGE # (10) HORIZONTAL_COUNTER
(
	.Clock	(   slow_clock   ),
	.Reset	( (oHcounter > 799) || Reset 		),
	.Initial	( 10'b0  			),
	.Enable	(  1'b1				),
	.Q			(	oHcounter      )
);

UPCOUNTER_POSEDGE # (10) VERTICAL_COUNTER
(
	.Clock	( slow_clock    ),
	.Reset	( (oVcounter > 520) || Reset ),
	.Initial	( 10'b0  			),
	.Enable	( wEndline            ),
	.Q			( oVcounter      )
);

endmodule*/
