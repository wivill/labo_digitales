module MULTIPLICADOR3 # (parameter SIZE=16)
(
	input wire [SIZE-1:0] iA,
	input wire [SIZE-1:0] iB,
	output reg Co,
	// output reg [2*SIZE - 1:0] Res,
	output reg [SIZE:0] Res,
	output reg [2*SIZE-1:0] out
);

wire Ci;


	genvar i,j; // Variables que usan los FOR statement para instanciar en compilación cada bloque
	// genvar j;
	generate
		for (i=0; i<SIZE-1; i=i+1) begin

			if (i==0) begin
				always @ ( * ) begin
					Res[i] = iA[i]&iB[i];

					generate
						for (j=1; j<SIZE-1; j=j+1) begin
							{Ci, Res[j]} = iA[j]&iB[i] + iA[j-1]&iB[i+1] + Ci;
						end
					endgenerate

					Res[SIZE] = iA[SIZE-1]&iB[i+1] + Ci;

				end


			end

			else begin

			end


		end
	endgenerate

endmodule
