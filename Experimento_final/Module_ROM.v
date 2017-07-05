`timescale 1ns / 1ps
`include "Definitions.v"

module ROM
   (
    input wire [15:0] iAddress,
    output reg [27:0] oInstruction
    );
   always @  ( iAddress )
      begin
	 case (iAddress)

// Tablero
/*        0: oInstruction = { `NOP ,24'd4000 };
 	1: oInstruction = { `STO ,`R1, 16'd0 };	          //R1 => Col
 	2: oInstruction = { `STO ,`R2, 16'd0 };	          //R2 => Fil
 	3: oInstruction = { `STO ,`R7, 16'd32 };	  //R7 => ADD
 	4: oInstruction = { `STO ,`R6, 16'd255 };	  //End

 	5: oInstruction = { `STO ,`R4, 16'd31 };	  //R4 => Lmite Fil
 	6: oInstruction = { `CALL ,`SaveWhite, 16'd0 };
 	7: oInstruction = { `ADD ,`R4, `R4, `R7  };
 	8: oInstruction = { `CALL ,`SaveBlack, 16'd0 };
 	9: oInstruction = { `BGE , 8'b0, `R4, `R6  };
 	10: oInstruction = { `ADD ,`R4, `R4, `R7  };
 	11: oInstruction = { `JMP ,8'd6, 16'b0  };

 		//TAG SaveWhite

 	50: oInstruction = { `STO ,`R1, 16'd0 };	//R1 => Col
 	51: oInstruction = { `STO ,`R3, 16'd31 };	//R3 => Lmite Col
 		//TAG WhiteWhite
 	52: oInstruction = { `VGA ,`COLOR_WHITE, `R1, `R2  };
 	53: oInstruction = { `INC ,`R1, `R1, 8'd0  };
 	54: oInstruction = { `NOP ,24'd4000       };
 	55: oInstruction = { `BLE ,`WhiteWhite, `R1, `R3  };
 	56: oInstruction = { `ADD ,`R3, `R3, `R7  };
 		//TAG WhiteBlack
 	57: oInstruction = { `VGA ,`COLOR_BLACK, `R1, `R2  };
 	58: oInstruction = { `INC ,`R1, `R1, 8'd0  };
 	59: oInstruction = { `NOP ,24'd4000       };
 	60: oInstruction = { `BLE ,`WhiteBlack, `R1, `R3  };
 	61: oInstruction = { `ADD ,`R3, `R3, `R7  };
 	62: oInstruction = { `BLE ,`WhiteWhite, `R1, `R6  };
 	63: oInstruction = { `INC ,`R2, `R2, 8'd0  };
 	64: oInstruction = { `NOP ,24'd4000       };
 	65: oInstruction = { `BLE ,`SaveWhite, `R2, `R4  };
 	66: oInstruction = { `RET ,24'd0 };

 		//TAG SaveBlack
 	70: oInstruction = { `STO ,`R1, 16'd0 };	//R1 => Col
 	71: oInstruction = { `STO ,`R3, 16'd31 };	//R3 => Lmite Col
 		//TAG BlackBlack
 	72: oInstruction = { `VGA ,`COLOR_BLACK, `R1, `R2  };
 	73: oInstruction = { `INC ,`R1, `R1, 8'd0  };
 	74: oInstruction = { `NOP ,24'd4000       };
 	75: oInstruction = { `BLE ,`BlackBlack, `R1, `R3  };
 	76: oInstruction = { `ADD ,`R3, `R3, `R7  };
 		//TAG BlackWhite
 	77: oInstruction = { `VGA ,`COLOR_WHITE, `R1, `R2  };
 	78: oInstruction = { `INC ,`R1, `R1, 8'd0  };
 	79: oInstruction = { `NOP ,24'd4000       };
 	80: oInstruction = { `BLE ,`BlackWhite, `R1, `R3  };
 	81: oInstruction = { `ADD ,`R3, `R3, `R7  };
 	82: oInstruction = { `BLE ,`BlackBlack, `R1, `R6  };
 	83: oInstruction = { `INC ,`R2, `R2, 8'd0  };
 	84: oInstruction = { `NOP ,24'd4000       };
 	85: oInstruction = { `BLE ,`SaveBlack, `R2, `R4  };
 	86: oInstruction = { `RET ,24'd0 };*/


/* //Mtodo 1 para despliegue de franjas sin VRAM
	    0: oInstruction  = {`NOP , 24'd4000};
	    1: oInstruction  = {`STO, `R0, 16'd336}; //col=0
	    2: oInstruction  = {`STO, `R1, 16'd141}; //row=0
	    3: oInstruction  = {`STO, `R2, 16'd1}; //1 constante
	    4: oInstruction  = {`STO, `R3, 16'd205}; //ancho franja


	    //----------------------------------------------------------
	    5: oInstruction  = {`STO, `R4, 16'd59}; //altura franja

	    //LOOP_GREEN
	    6: oInstruction  = {`Display_VGA, `COLOR_GREEN, `R1, `R0};
	    7: oInstruction  = {`ADD, `R1, `R1, `R2};
	    8: oInstruction  = {`BLE , `LOOP_GREEN, `R1, `R3};
	    //----------------------------------------------------------
	    9: oInstruction  = {`ADD, `R3, `R3, 16'd64};
 //altura franja

	    //LOOP_RED
	    10: oInstruction  = {`Display_VGA, `COLOR_RED,`R1, `R0};
	    11: oInstruction  = {`ADD, `R1, `R1, `R2};
	    12: oInstruction  = {`BLE , `LOOP_RED, `R1, `R3};
	    //----------------------------------------------------------
	    13: oInstruction  = {`ADD, `R3, `R3, 16'd64}; //altura franja

	    //LOOP_MAGENTA
	    14: oInstruction  = {`Display_VGA, `COLOR_MAGENTA, `R1, `R1};
	    15: oInstruction  = {`ADD, `R1, `R1, `R2};
	    16: oInstruction  = {`BLE , `LOOP_MAGENTA, `R1, `R3};
	    //----------------------------------------------------------
	    17: oInstruction  = {`ADD, `R3, `R3, 16'd64}; //altura franja

	    //LOOP_BLUE
	    18: oInstruction  = {`Display_VGA, `COLOR_BLUE, `R1, `R1};
	    19: oInstruction  = {`ADD, `R1, `R1, `R2};
	    20: oInstruction  = {`BLE , `LOOP_BLUE, `R1, `R3};
		 //
       21: oInstruction  = {`ADD, `R3, `R3, 16'd64};
*/

 //Franjas en pantalla usando instancia de VRAM

	0: oInstruction = { `NOP ,24'd4000       };
	1: oInstruction = { `STO ,`R4, 16'd63 };	//R4 => Limite Col
	2: oInstruction = { `STO ,`R5, 16'd255 };	//R5 => Limite Fil

	3: oInstruction = { `STO ,`R7, 16'd0 };	//R7 => Fil 	Registros en donde se elige donde escribir en RAM, y la posicin en pantalla.
	4: oInstruction = { `STO ,`R6, 16'd0 };	//R8 => Col
	// J1
	5: oInstruction = { `VGA ,`COLOR_RED, `R7, `R6  };
	6: oInstruction = { `INC, `R7, `R7, 8'd0 };
	7: oInstruction = { `BLE, `J1, `R7, `R5 };
	8: oInstruction = { `STO ,`R7, 16'd0 };
	9: oInstruction = { `INC, `R6, `R6, 8'd0 };
	10: oInstruction = { `BLE, `J1, `R6, `R4 };

	11: oInstruction = { `STO ,`R7, 16'd0 };	//R7 => Fil
	12: oInstruction = { `STO ,`R4, 16'd127 };	//R4 => Limite Col
// J2
	13: oInstruction = { `VGA ,`COLOR_RED, `R7, `R6  };
	14: oInstruction = { `INC, `R7, `R7, 8'd0 };
	15: oInstruction = { `BLE, `J2, `R7, `R5 };
	16: oInstruction = { `STO ,`R7, 16'd0 };
	17: oInstruction = { `INC, `R6, `R6, 8'd0 };
	18: oInstruction = { `BLE, `J2, `R6, `R4 };

	19: oInstruction = { `STO ,`R7, 16'd0 };	//R7 => Fil
	20: oInstruction = { `STO ,`R4, 16'd191 };	//R4 => Limite Col
	// J3
	21: oInstruction = { `VGA ,`COLOR_MAGENTA, `R6, `R7  };
	22: oInstruction = { `INC, `R7, `R7, 8'd0 };
	23: oInstruction = { `BLE, `J3, `R7, `R5 };
	24: oInstruction = { `STO ,`R7, 16'd0 };
	25: oInstruction = { `INC, `R6, `R6, 8'd0 };
	26: oInstruction = { `BLE, `J3, `R6, `R4 };

	27: oInstruction = { `STO ,`R7, 16'd0 };	//R7 => Fil
	28: oInstruction = { `STO ,`R4, 16'd255 };	//R4 => Limite Col
	// J4
	29: oInstruction = { `VGA, `COLOR_WHITE, `R7, `R6  };
	30: oInstruction = { `INC, `R7, `R7, 8'd0 };
	31: oInstruction = { `BLE, `J4, `R7, `R5 };
	32: oInstruction = { `STO ,`R7, 16'd0 };
	33: oInstruction = { `INC, `R6, `R6, 8'd0 };
	34: oInstruction = { `BLE, `J4, `R6, `R5 };
	35: oInstruction = { `JMP, 8'd35, 16'b0 };

	36: oInstruction = { `INC, `R7, `R7, 8'd0 };
	37: oInstruction = { `NOP ,24'd4000       };
	38: oInstruction = { `VGA ,`COLOR_BLUE, `R7, `R6  };
	39: oInstruction = { `NOP ,24'd4000       };


    default:
	       oInstruction = { `NOP ,  24'd4000 };
	 endcase
      end
endmodule
