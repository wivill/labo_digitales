/* codigo requerido para realizar la multiplicacion de 4 bits, correspondiente a la parte 2 de la gúia de laboratorio*/
module mul4bits(output reg [15:0]wResult,input wire 	[3:0] A, input wire 	[3:0] B) ;


wire WCarry;



assign { wResult[0]} = (A[0] & B[0 ]);
assign {WCarry, wResult[1]} = (A[1] & B[0 ])+ (A[0] & B[1 ]) ;
assign {WCarry, wResult[2]} = (A[2] & B[0 ])+ (A[1] & B[1 ])+ (A[0] & B[2 ]) + WCarry;
assign {WCarry, wResult[3]} = (A[3] & B[0 ])+ (A[2] & B[1 ])+ (A[1] & B[2 ])+(A[0] & B[3]) + WCarry;
assign {WCarry, wResult[4]} = (A[3] & B[1 ])+ (A[2] & B[2 ])+ (A[1] & B[3 ]) + WCarry;
assign {WCarry, wResult[5]} = (A[3] & B[2 ])+ (A[2] & B[3 ]) + WCarry; 
assign {WCarry, wResult[6]} = (A[3] & B[3 ]) + WCarry;
assign {WCarry, wResult[7]} =  WCarry;




endmodule