`timescale 1ns / 1ps

//------------------------------------------------
module ADDER # (parameter SIZE= 4)
   (
    input wire [SIZE-1:0]  A,
    input wire [SIZE-1:0]  B,
    output wire [SIZE-1:0] Result,
    output wire 	   CarryO
    );

   assign {CarryO, Result} = A + B;

endmodule // ADDER


//------------------------------------------------
module MULT_MUX # (parameter ASIZE= 4) 
   (
    input wire [ASIZE-1:0] A,
    input wire [1:0] 	   B,
    output reg [ASIZE+1:0] Result
    );

   always @ (*)
      begin
	 case (B)
	    2'b00: Result = 0;
	    2'b01: Result = A;
	    2'b10: Result = {A, 1'b0};
	    2'b11: Result = {A, 1'b0} + A;
	 endcase
      end

endmodule // MULT_MUX


//----------------------------------------------------
module IMUL1_LOGIC4
   (	
	input wire [3:0]  A,
	input wire [3:0]  B,
	output wire [7:0] Result
	);

   wire [3:0] 		  wSumOp0 [2:0];
   wire [3:0] 		  wSumOp1 [2:0];

   wire [3:0] 		  wAddResult [2:0];
   wire 		  wCarryOut [2:0];


   assign wSumOp0[0] = { 1'b0 ,  A[3]&B[0], A[2]&B[0], A[1]&B[0]};
   assign wSumOp1[0] = { A[3]&B[1],  A[2]&B[1], A[1]&B[1], A[0]&B[1]};

   assign wSumOp0[1] = { wCarryOut[0] ,  wAddResult[0][3:1]};
   assign wSumOp1[1] = { A[3]&B[2],  A[2]&B[2], A[1]&B[2], A[0]&B[2]};

   assign wSumOp0[2] = { wCarryOut[1] ,  wAddResult[1][3:1]};
   assign wSumOp1[2] = { A[3]&B[3],  A[2]&B[3], A[1]&B[3], A[0]&B[3]};


   ADDER # (4) SUM1 (.A(wSumOp0[0]), .B(wSumOp1[0]), .Result(wAddResult[0]), .CarryO(wCarryOut[0]));
   ADDER # (4) SUM2 (.A(wSumOp0[1]), .B(wSumOp1[1]), .Result(wAddResult[1]), .CarryO(wCarryOut[1]));
   ADDER # (4) SUM3 (.A(wSumOp0[2]), .B(wSumOp1[2]), .Result(wAddResult[2]), .CarryO(wCarryOut[2]));

   assign Result = {wCarryOut[2], wAddResult[2], wAddResult[1][0], wAddResult[0][0], A[0]&B[0]};

endmodule // IMUL1_LOGIC4


//----------------------------------------------------
module IMUL1_LOGIC #(parameter SIZE = 16)
   (	
	input wire [SIZE-1:0] 	   A,
	input wire [SIZE-1:0] 	   B,
	output wire [(2*SIZE)-1:0] Result
	);

   wire [SIZE-1:0] 		   wSumOp0 [SIZE-2:0];
   wire [SIZE-1:0] 		   wSumOp1 [SIZE-2:0];

   wire [SIZE-1:0] 		   wAddResult [SIZE-2:0];
   wire [SIZE-2:0] 		   wCarryOut;

   
   
   //---------------------------------
   genvar 			   i,j;
   generate
      //Entradas del 1er sumador
      assign wSumOp0[0][SIZE-1] = 0;
      assign wSumOp1[0][SIZE-1]  = A[SIZE-1] & B[1];

      for (i = 0; i < SIZE-1; i = i + 1)
	 begin: ANDMAT
	    assign wSumOp0[0][i] = A[i+1] & B[0];
	    assign wSumOp1[0][i] = A[i] & B[1];
	 end

      //Primer operando demás sumadores
      for (i = 1; i < SIZE-1; i = i + 1) 
	 begin: WSUMOP0
	    assign wSumOp0[i] = {wCarryOut[i-1], wAddResult[i-1][(SIZE-1):1]};
	 end
      
      //Segundo operando demás sumadores
      for (i = 1; i < SIZE-1; i = i + 1)
	 begin: WSUMOP1I
	    for (j = 0; j < SIZE; j = j + 1)
	       begin: WSUMOP1J
		  assign wSumOp1[i][j] = A[j] & B[i+1];
	       end
	 end
      
      //Instancias de los sumadores
      for (i = 0; i < SIZE-1; i = i + 1) 
	 begin: ADD
	    ADDER #(SIZE) add 
	       (
		.A(wSumOp0[i]), 
		.B(wSumOp1[i]), 
		.Result(wAddResult[i]), 
		.CarryO(wCarryOut[i])
		);
	 end
      
      //Construcción del resultado
      assign Result[0] = A[0] & B[0]; 
      assign Result[(2*(SIZE-1)):(SIZE-1)] = wAddResult[SIZE-2];
      assign Result[(2*SIZE)-1] = wCarryOut[SIZE-2];
      
      for (i = 1; i < SIZE-1; i = i + 1) 
	 begin: RESULT
	    assign Result[i] = wAddResult[i-1][0];
	 end
      
   endgenerate
   //---------------------------------

endmodule // IMUL1_LOGIC


//----------------------------------------------------
module IMUL2_LOGIC4
   (
    input wire [3:0]  A,
    input wire [3:0]  B,
    output wire [7:0] Result
    );
   wire [5:0] 	      wMultResult0, wMultResult1;
   wire [5:0] 	      wSumOp0, wSumOp1, wAddResult;
   wire 	      wCarryOut;
   
   MULT_MUX #(4) mux0 
      (
       .A(A), 
       .B(B[1:0]), 
       .Result(wMultResult0)
       );
   
   MULT_MUX #(4) mux1 
      (
       .A(A), 
       .B(B[3:2]), 
       .Result(wMultResult1)
       );

   assign wSumOp0 = {2'b0,wMultResult0[5:2]};
   assign wSumOp1 = wMultResult1;
   assign Result = {wAddResult,wMultResult0[1:0]};
   
   ADDER #(6) add0 
      (
       .A(wSumOp0), 
       .B(wSumOp1), 
       .Result(wAddResult), 
       .CarryO(wCarryOut)
       );

endmodule // IMUL2_LOGIC4


//----------------------------------------------------
module IMUL2_LOGIC #(parameter SIZE = 16)
   (	
	input wire [SIZE-1:0] 	   A,
	input wire [SIZE-1:0] 	   B,
	output wire [(2*SIZE)-1:0] Result
	);

   wire [SIZE+1:0] 		   wMultResult [(SIZE/2)-1:0];
   
   wire [SIZE+1:0] 		   wSumOp0 [(SIZE/2)-2:0];
   wire [SIZE+1:0] 		   wSumOp1 [(SIZE/2)-2:0];

   wire [SIZE+1:0] 		   wAddResult [(SIZE/2)-2:0];
   wire [(SIZE/2)-2:0] 		   wCarryOut;


   //---------------------------------   
   genvar 			   i;
   generate
      //Resultados MULT
      for (i = 0; i < (SIZE/2); i = i + 1)
	 begin: MULTMAT
	    MULT_MUX #(SIZE) mult_mux 
	       (
		.A(A), 
		.B(B[(2*i)+:2]), 
		.Result(wMultResult[i])
		);
	 end

      //Operandos primer sumador
      assign wSumOp0[0] = {2'b0, wMultResult[0][SIZE+1:2]};
      assign wSumOp1[0] = wMultResult[1];			  
      
      //Operandos demás sumadores
      for (i = 1; i < (SIZE/2)-1; i = i + 1)
	 begin: SUMOP
	    assign wSumOp0[i] = {1'b0, wCarryOut[i-1], wAddResult[i-1][SIZE+1:2]};
	    assign wSumOp1[i] = wMultResult[i+1];
	 end
      
      //Instancias de los sumadores
      for (i = 0; i < (SIZE/2)-1; i = i + 1) 
	 begin: ADD
	    ADDER #(SIZE+2) add
	       (
		.A(wSumOp0[i]), 
		.B(wSumOp1[i]), 
		.Result(wAddResult[i]), 
		.CarryO(wCarryOut[i])
		);
	 end

      //Construcción del resultado
      assign Result[1:0] = wMultResult[0][1:0]; 
      assign Result[(2*SIZE-1):(SIZE-2)] = wAddResult[(SIZE/2)-2];
      
      for (i = 1; i < (SIZE/2)-1; i = i + 1) 
	 begin: RESULT
	    assign Result[(2*i)+:2] = wAddResult[i-1][1:0];
	 end
      
   endgenerate


endmodule // IMUL2_LOGIC
