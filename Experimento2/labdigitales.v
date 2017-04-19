`timescale 1ns / 1ps

/* codigo requerido para realizar la multiplicacion de 4 bits, correspondiente a la parte 2 de la gúia de laboratorio*/
module mul1bit(
	output wire wResult,
	output wire CarryOut,
	input wire CarryIn,
	input wire 	 A, 
	input wire 	 B
	);

assign {CarryOut, wResult} = (A + B + CarryIn);
	
endmodule



module mul4bits(
	output wire [15:0]wResult,
	input wire 	[3:0] A, 
	input wire 	[3:0] B) ;
	//caja1
	wire caja1;
	wire carry1salida;
	//caja2a
	wire caja2a;
	wire carry2asalida;
	wire resultado2asalida;

	//caja2b
	wire caja2B;
	wire carry2Bsalida;
	wire resultado2Bsalida;
	
	//caja3A
	wire caja3A;
	wire carry3Asalida;
	wire resultado3Asalida;
	
	//caja3B
	wire caja3B;
	wire carry3Bsalida;
	wire resultado3Bsalida;
	
	//caja3C
	wire caja3C;
	wire carry3Csalida;
	wire resultado3BCsalida;
	
	//caja4A
	wire caja4A;
	wire carry4Asalida;
	wire resultado4Asalida;
	
	//caja4B
	wire caja4B;
	wire carry4Bsalida;
	wire resultado4Bsalida;
	
	//caja4C
	wire caja4C;
	wire carry4Csalida;
	wire resultado4Csalida;
	
	//caja5A
	wire caja5A;
	wire carry5Asalida;
	wire resultado5Asalida;
	
	//caja5B
	wire caja5B;
	wire carry5Bsalida;
	wire resultado5Bsalida;
	
	//caja6
	wire caja6;
	wire carry6salida;
	wire resultado6salida;
	
assign wResult[0] = A[0] & B[0 ] ;
	
mul1bit cajamodo1 (wResult[1],carry1salida, 1'b0, (A[0] & B[1 ]),A[1] & B[0 ] );

mul1bit cajamodo2a (resultado2asalida,carry2asalida, carry1salida, (A[2] & B[0 ]),A[1] & B[1 ] );

mul1bit cajamodo2B (wResult[2],carry2Bsalida,  1'b0, resultado2asalida,A[0] & B[2 ] );

mul1bit cajamodo3A(resultado3Asalida,carry3Asalida,  carry2asalida, A[2] & B[1 ],A[3] & B[0 ] );

mul1bit cajamodo3B(resultado3Bsalida,carry3Bsalida,  carry2Bsalida, resultado3Asalida,A[1] & B[2 ] );

mul1bit cajamodo3C(wResult[3],carry3Csalida,  1'b0, resultado3Bsalida,A[0] & B[3 ] );

mul1bit cajamodo4A(resultado4Asalida,carry4Asalida,  carry3Asalida,1'b0,A[3] & B[1 ] );

mul1bit cajamodo4B(resultado4Bsalida,carry4Bsalida,  carry3Bsalida,resultado4Asalida,A[2] & B[2 ] );

mul1bit cajamodo4C(wResult[4],carry4Csalida,  carry3Csalida,resultado4Bsalida,A[1] & B[3 ] );

mul1bit cajamodo5A(resultado5Asalida,carry5Asalida,  carry4Bsalida,carry4Asalida,A[3] & B[2 ] );

mul1bit cajamodo5B(wResult[5],carry5Bsalida,  carry4Csalida,resultado5Asalida,A[2] & B[3 ] );

mul1bit cajamodo6(wResult[6],wResult[7],  carry5Bsalida,carry5Asalida,A[3] & B[3 ] );

endmodule

/*wire WCarryOut1;
wire WCarryOut2;
wire WCarryOut3;
wire WCarryOut4;
wire WCarryOut5;
wire WCarryOut6;
wire WCarryOut7;
wire WCarryOut8;

assign {WCarryOut1, wResult[0]} = (A[0] & B[0 ]);
assign {WCarryOut2, wResult[1]} = (A[1] & B[0 ])+ (A[0] & B[1 ]) + WCarryOut1 ;
assign {WCarryOut3, wResult[2]} = (A[2] & B[0 ])+ (A[1] & B[1 ])+ (A[0] & B[2 ]) + WCarryOut2;
assign {WCarryOut4, wResult[3]} = (A[3] & B[0 ])+ (A[2] & B[1 ])+ (A[1] & B[2 ])+(A[0] & B[3]) +WCarryOut3;
assign {WCarryOut5, wResult[4]} = (A[3] & B[1 ])+ (A[2] & B[2 ])+ (A[1] & B[3 ]) + WCarryOut4;
assign {WCarryOut6, wResult[5]} = (A[3] & B[2 ])+ (A[2] & B[3 ]) + WCarryOut5; 
assign {WCarryOut7, wResult[6]} = (A[3] & B[3 ]) + WCarryOut6;
assign {WCarryOut8, wResult[7]} =  WCarryOut7;*/




