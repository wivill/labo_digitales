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
//----------------------------------------------------------------------
module MUX # ( parameter SIZE=16 )
(
	input wire						Clock,
	input wire [SIZE-1:0]		in0,
	input wire [SIZE-1:0]		in1,
	input wire [SIZE-1:0]  		in2,
	input wire [SIZE-1:0]		in3,
	input wire [1:0]				select,
	output reg [SIZE-1:0]	   out
);

always @ (*) 
begin
		case(select)
			2'b00 :
				begin
					out <= in0;
				end
			2'b01 :
				begin
					out <= in1;
				end
			2'b10 :
				begin
					out <= in2;
				end
			2'b11 :
				begin
					out <= in3;
				end
			default :
				begin
					out <= 16'hCAFE;
				end
		endcase	
 
end//always

endmodule

