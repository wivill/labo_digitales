`timescale 1ns / 1ps
`include "Defintions.v"

`define EXIT 8'd174
`define LOOP_GREEN 8'd6
`define LOOP_RED 8'd13
`define LOOP_MAGENTA 8'd20
`define LOOP_BLUE 8'd27

module ROM
   (
    input wire [15:0] iAddress,
    output reg [27:0] oInstruction
    );
   always @ ( iAddress )
      begin
	 case (iAddress)

	    0: oInstruction  = {`NOP , 24'd4000};
	    1: oInstruction  = {`STO, `R0, 16'd0}; //col=0
	    2: oInstruction  = {`STO, `R1, 16'd0}; //row=0
	    3: oInstruction  = {`STO, `R2, 16'd1}; //1 constante
	    4: oInstruction  = {`STO, `R3, 16'd399}; //ancho franja
	    
	    
	    //----------------------------------------------------------
	    5: oInstruction  = {`STO, `R4, 16'd59}; //altura franja
	    
	    //LOOP_GREEN
	    6: oInstruction  = {`Display_VGA, `COLOR_GREEN, `R1, `R0};
	    7: oInstruction  = {`ADD, `R0, `R0, `R2};
	    8: oInstruction  = {`BLE , `LOOP_GREEN, `R0, `R3};
	    9: oInstruction  = {`STO, `R0, 16'd0}; //col=0
	    10: oInstruction  = {`ADD, `R1, `R1, `R2};
	    11: oInstruction  = {`BLE , `LOOP_GREEN, `R1, `R4};

	    
	    //----------------------------------------------------------
	    12: oInstruction  = {`STO, `R4, 16'd119}; //altura franja
	    
	    //LOOP_RED
	    13: oInstruction  = {`Display_VGA, `COLOR_RED, `R1, `R0};
	    14: oInstruction  = {`ADD, `R0, `R0, `R2};
	    15: oInstruction  = {`BLE , `LOOP_RED, `R0, `R3};
	    16: oInstruction  = {`STO, `R0, 16'd0}; //col=0
	    17: oInstruction  = {`ADD, `R1, `R1, `R2};
	    18: oInstruction  = {`BLE , `LOOP_RED, `R1, `R4};


	    //----------------------------------------------------------
	    19: oInstruction  = {`STO, `R4, 16'd179}; //altura franja
	    
	    //LOOP_MAGENTA
	    20: oInstruction  = {`Display_VGA, `COLOR_MAGENTA, `R1, `R0};
	    21: oInstruction  = {`ADD, `R0, `R0, `R2};
	    22: oInstruction  = {`BLE , `LOOP_MAGENTA, `R0, `R3};
	    23: oInstruction  = {`STO, `R0, 16'd0}; //col=0
	    24: oInstruction  = {`ADD, `R1, `R1, `R2};
	    25: oInstruction  = {`BLE , `LOOP_MAGENTA, `R1, `R4};


	    //----------------------------------------------------------
	    26: oInstruction  = {`STO, `R4, 16'd239}; //altura franja
	    
	    //LOOP_BLUE
	    27: oInstruction  = {`Display_VGA, `COLOR_BLUE, `R1, `R0};
	    28: oInstruction  = {`ADD, `R0, `R0, `R2};
	    29: oInstruction  = {`BLE , `LOOP_BLUE, `R0, `R3};
	    30: oInstruction  = {`STO, `R0, 16'd0}; //col=0
	    31: oInstruction  = {`ADD, `R1, `R1, `R2};
	    32: oInstruction  = {`BLE , `LOOP_BLUE, `R1, `R4};

	    33: oInstruction = {`JMP , 8'd33 , 16'b0}; //Infinite loop
	    
	    default:
	       oInstruction = { `LED ,  24'b10101010 };
	 endcase
      end
endmodule
