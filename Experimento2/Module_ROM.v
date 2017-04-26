`timescale 1ns / 1ps
`include "Defintions.v"

`define LOOP1 8'd8
`define LOOP2 8'd5
module ROM
(
	input  wire[15:0]  		iAddress,
	output reg [27:0] 		oInstruction
);	
always @ ( iAddress )
begin
	case (iAddress)

	0: oInstruction = { `NOP ,24'd4000    };
	1: oInstruction = { `STO , `R7,16'hff }; //para restar hff
	2: oInstruction = { `STO ,`R3,16'h0002     };
    //3: oInstruction = { `STO, `R4, 16'hff32};	
	3: oInstruction = { `STO, `R4, 16'h0004};
	4: oInstruction = { `STO, `R5,16'd0     }; 
    5: oInstruction = { `MUL4bits, `R5, `R4, `R3 };	
    /* instrucciones para multiplicación a 16 bits, parte alta del resultado se guarda en 
    registro R8 de la ram, y la parte baja se guarda en el registro indicado en la instrucción
    */
    6: oInstruction = { `STO ,`R3,16'sh8002 };//-2
	7: oInstruction = { `STO, `R4, 16'sh0008};// 8
	8: oInstruction = { `STO, `R5,16'd0     }; 	// guarda parte baja en registro R5
	9: oInstruction = { `SMUL, `R5, `R4, `R3 }; 
	default:
		oInstruction = { `LED ,  24'b10101010 };		//NOP
	endcase	
end
	
endmodule
