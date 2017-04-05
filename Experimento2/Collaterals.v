`timescale 1ns / 1ps
//------------------------------------------------
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

//Multiplicador ejercicio 2 y 3

module MULTIPLICADOR3 # (parameter SIZE=16)
(
	input wire [SIZE-2:2] Ci,
	input wire [SIZE-1:0] iA,
	input wire [SIZE-1:0] iB,
	output reg Co,
	output reg [SIZE:0] Res
);
	assign Ci[0] = 1'b0;
	assign Res[0] = iA[0]&iB[0];
	assign Co = Ci[SIZE];
	
	genvar i;
	generate
		for (i=0; i<SIZE, i=i+1)
		begin: mult_cell
			assign {Ci[i+1],Res[i]} = 
	
	endgenerate

endmodule

//----------------------------------------------------------------------


