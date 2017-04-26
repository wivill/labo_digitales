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
	1: oInstruction = { `STO, `R7, 16'hfff }; //para restar hff
	2: oInstruction = { `STO, `R3, 16'h1129     }; 
	3: oInstruction = { `STO, `R4, 16'h0036};
	4: oInstruction = { `STO, `R2, 16'h1136};
	5: oInstruction = { `STO, `R5, 16'd0     };  //j
	6: oInstruction = { `MUL2, `R5, `R4, `R3 }; 
	7: oInstruction = { `MUL2, `R5, `R4, `R7 };
	8: oInstruction = { `MUL2, `R5, `R2, `R7 };
/*//LOOP2:
	5: oInstruction = { `LED ,8'b0,`R7,8'b0 };
	6: oInstruction = { `STO ,`R1,16'h0     }; 	
	7: oInstruction = { `STO ,`R2,16'd500 };
//LOOP1:	
	8: oInstruction = { `ADD ,`R1,`R1,`R3    }; 
	9: oInstruction = { `BLE ,`LOOP1,`R1,`R2 }; 
	
	10: oInstruction = { `ADD ,`R5,`R5,`R3    };
	11: oInstruction = { `BLE ,`LOOP2,`R5,`R4 };	
	12: oInstruction = { `NOP ,24'd4000       }; 
	13: oInstruction = { `SUB ,`R7,`R7,`R3    };
	14: oInstruction = { `JMP ,  8'd2,16'b0   };*/
	default:
		oInstruction = { `LED ,  24'b10101010 };		//NOP
	endcase	
end
	
endmodule
