`include "labdigitales.v"

module MULTIPLICADOR3 # (parameter SIZE=16)
(
	input wire [SIZE-1:0] iA,
	input wire [SIZE-1:0] iB,
	output wire Co,
	output wire [SIZE:0] Res,
	output wire [2*SIZE-1:0] out
);
wire [SIZE-1:0] Ci; // Considerar si se ocupa o no

// module mul1bit(
// 	output wire wResult,
// 	output wire CarryOut,
// 	input wire CarryIn,
// 	input wire 	 A,
// 	input wire 	 B
// 	);


// mul1bit celda(
// 	.wResult(Res),
// 	.CarryOut(Co),
// 	.CarryIn(Ci), // Considerar si se ocupa o no
// 	.A(iA),
// 	.B(iB)
// 	);

	genvar i,j; // Variables que usan los FOR statement para instanciar en compilación cada bloque
	generate
		for (i=0; i<SIZE-1; i=i+1) begin
			if (i==0) begin
				assign out[0] = iA[0]&iB[0];

			end
			else begin : CELL
				for (j=0; j<SIZE-1; j=j+1) begin


				end
			end
		end
	endgenerate

endmodule
