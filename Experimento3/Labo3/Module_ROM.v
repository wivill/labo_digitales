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
	2: oInstruction = { `STO ,`R3,16'h2302     };
	3: oInstruction = { `STO, `R4, 16'h2121};
	4: oInstruction = { `STO, `R5, 16'h2121    }; 
    	5: oInstruction = { `LCD, `R5, `R4, `R3 };	
    /* instrucciones para multiplicación a 16 bits, parte alta del resultado se guarda en 
    registro R8 de la ram, y la parte baja se guarda en el registro indicado en la instrucción
    */
    6: oInstruction = { `STO ,`R3,16'h3252 };//-2
	7: oInstruction = { `STO, `R4, 16'h2323};// 8
	8: oInstruction = { `STO, `R5,16'd0     }; 	// guarda parte baja en registro R5
	9: oInstruction = { `LCD, `R5, `R4, `R3 };
	10: oInstruction = { `STO, `R7, 16'hfff0 }; //para restar hff
	11: oInstruction = { `STO, `R3, 16'h1129     }; 
	12: oInstruction = { `STO, `R4, 16'h4536};
	13: oInstruction = { `STO, `R2, 16'h1136};
	14: oInstruction = { `STO, `R5, 16'd0     };  //j
	15: oInstruction = { `NOP ,24'd4000    };
	16: oInstruction = { `NOP ,24'd4000    };
	17: oInstruction = { `NOP ,24'd4000    };
	18: oInstruction = { `NOP ,24'd4000    };
	19: oInstruction = { `NOP ,24'd4000    };
	20: oInstruction = { `NOP ,24'd4000    };
	21: oInstruction = { `LCD, `R5, `R4, `R3 }; 
	22: oInstruction = { `NOP ,24'd4000    };
	23: oInstruction = { `NOP ,24'd4000    };
	24: oInstruction = { `NOP ,24'd4000    };
	25: oInstruction = { `NOP ,24'd4000    };
	26: oInstruction = { `NOP ,24'd4000    };
	27: oInstruction = { `NOP ,24'd4000    };
	28: oInstruction = { `NOP ,24'd4000    };
	29: oInstruction = { `LCD, `R5, `R3, `R4 };
    30: oInstruction = { `STO ,`R3,16'h3252 };//-2
    31: oInstruction = { `STO, `R4, 16'h484A};// 8
	32: oInstruction = { `STO, `R5,16'd0     }; 	// guarda parte baja en registro R5
	33: oInstruction = { `NOP ,24'd4000    };
	34: oInstruction = { `NOP ,24'd4000    };
	35: oInstruction = { `NOP ,24'd4000    };
	36: oInstruction = { `NOP ,24'd4000    };
	37: oInstruction = { `NOP ,24'd4000    };
	38: oInstruction = { `NOP ,24'd4000    };
	39: oInstruction = { `LCD, `R5, `R4, `R3 };
	40: oInstruction = { `STO, `R7, 16'hfff0 }; //para restar hff
	41: oInstruction = { `STO, `R3, 16'h1129     }; 
	42: oInstruction = { `STO, `R4, 16'h8080};
	43: oInstruction = { `STO, `R2, 16'h1136};
	44: oInstruction = { `STO, `R5, 16'd0     };  //j
	45: oInstruction = { `NOP ,24'd4000    };
	46: oInstruction = { `NOP ,24'd4000    };
	47: oInstruction = { `NOP ,24'd4000    };
	48: oInstruction = { `NOP ,24'd4000    };
	49: oInstruction = { `NOP ,24'd4000    };
	50: oInstruction = { `NOP ,24'd4000    };
	51: oInstruction = { `LCD, `R5, `R4, `R3 }; 
	52: oInstruction = { `NOP ,24'd4000    };
	53: oInstruction = { `LCD, `R5, `R3, `R4 };
	default:
		oInstruction = { `NOP ,24'd4000    };		//NOP
	endcase	
end
	
endmodule
