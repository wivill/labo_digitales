`timescale 1ns / 1ps
`ifndef DEFINITIONS_V
`define DEFINITIONS_V

`default_nettype none
`define NOP   4'd0
`define LED   4'd2
`define BLE   4'd3
`define STO   4'd4
`define ADD   4'd5
`define JMP   4'd6
`define SUB   4'd7
`define SMUL  4'd8
`define MUL2  4'd9
`define MUL4bits 4'd10
`define Display_VGA 4'd11

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
 `define COLOR_BLACK 3'd0
 `define COLOR_BLUE 3'd1 
 `define COLOR_GREEN 3'd2
 `define COLOR_CYAN 3'd3
 `define COLOR_RED 3'd4
 `define COLOR_MAGENTA 3'd5
 `define COLOR_YELLOW 3'd6
 `define COLOR_WHITE 3'd7

 /*`define HSYNC_BP_T 16'd47
 `define HSYNC_FP_T 16'd47
 `define HSYNC_DISP_T 16'd384000
 `define HSYNC_PULSE_T 16'd95

 `define VSYNC_BP_T 32'd23200
 `define VSYNC_FP_T 32'd8000
 `define VSYNC_DISP_T 32'd384000
 `define VSYNC_PULSE_T 32'd1600*/

`endif
