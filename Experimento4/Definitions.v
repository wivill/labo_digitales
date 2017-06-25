`timescale 1ns / 1ps
`ifndef DEFINITIONS_V
`define DEFINITIONS_V

`default_nettype none

// instrucciones
`define NOP   4'd0
`define STO   4'd1
`define INC   4'd2 //Destination = Source + 1
`define VGA   4'd3
`define BGE   4'd4
`define JMP   4'd5
`define BLE   4'd6
`define ADD	  4'd7
`define CALL  4'd8
`define RET	  4'd9
`define SUB   4'd10
// `define SMUL  4'd11
// `define MUL2  4'd12
// `define MUL4bits 4'd13
//`define Display_VGA 4'd14


//Registros en RAM
`define R0 8'd0
`define R1 8'd1
`define R2 8'd2
`define R3 8'd3
`define R4 8'd4
`define R5 8'd5
`define R6 8'd6
`define R7 8'd7
`define Rh 8'd8

//VGA Colors
`define COLOR_BLACK   8'b00000000
`define COLOR_BLUE    8'b00000001
`define COLOR_GREEN   8'b00000010
`define COLOR_CYAN    8'b00000011
`define COLOR_RED     8'b00000100
`define COLOR_MAGENTA 8'b00000101
`define COLOR_YELLOW  8'b00000110
`define COLOR_WHITE   8'b00000111

//Código PS2
`define W 8'h1D
`define A 8'h1C
`define S 8'h1B
`define D 8'h23

// Definiciones para tablero de ajedrez
`define SaveWhite 8'd50
`define WhiteWhite 8'd52
`define WhiteBlack 8'd57

`define SaveBlack 8'd70
`define BlackBlack 8'd72
`define BlackWhite 8'd77

// Definiciones para desplegar colores

`define J1 8'd5
`define J2 8'd13
`define J3 8'd21
`define J4 8'd29

`define EXIT 8'd174
`define LOOP_GREEN 8'd6
`define LOOP_RED 8'd13
`define LOOP_MAGENTA 8'd20
`define LOOP_BLUE 8'd27


 /*`define HSYNC_BP_T 16'd47
 `define HSYNC_FP_T 16'd47
 `define HSYNC_DISP_T 16'd384000
 `define HSYNC_PULSE_T 16'd95

 `define VSYNC_BP_T 32'd23200
 `define VSYNC_FP_T 32'd8000
 `define VSYNC_DISP_T 32'd384000
 `define VSYNC_PULSE_T 32'd1600*/

`endif
