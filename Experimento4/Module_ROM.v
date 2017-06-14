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
	    default:
	       oInstruction = { `LED ,  24'b10101010 };
	 endcase
      end
endmodule
