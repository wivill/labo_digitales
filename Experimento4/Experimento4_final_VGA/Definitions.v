`timescale 1ns / 1ps
`ifndef DEFINTIONS_V
 `define DEFINTIONS_V
 `default_nettype none	
 `define NOP    4'd0
 `define LED    4'd2
 `define BLE    4'd3
 `define STO    4'd4
 `define ADD    4'd5
 `define JMP    4'd6
 `define SUB    4'd7
 `define SMUL   4'd8
 `define SHL 4'd12
 `define CALL 4'd13
 `define RET 4'd14
 `define VGA 4'd15

  //Keyboard 
 `define A 8'h1C
 `define S 8'h1B
 `define W 8'h1D
 `define D 8'h23

  //Colors
 `define COLOR_BLACK 8'd0
 `define COLOR_BLUE 8'd1 
 `define COLOR_GREEN 8'd2
 `define COLOR_CYAN 8'd3
 `define COLOR_RED 8'd4
 `define COLOR_MAGENTA 8'd5
 `define COLOR_YELLOW 8'd6
 `define COLOR_WHITE 8'd7

 //parameters
 `define VMEM_DATA_WIDTH 3
 `define VMEM_X_WIDTH 10
 `define VMEM_Y_WIDTH 9
 `define VMEM_X_SIZE 400
 `define VMEM_Y_SIZE 240
 `define VGA_X_RES 640
 `define VGA_Y_RES 480

    
  //RAM registers
 `define R0 8'd0
 `define R1 8'd1
 `define R2 8'd2
 `define R3 8'd3
 `define R4 8'd4
 `define R5 8'd5
 `define R6 8'd6
 `define R7 8'd7
 `define R8 8'd8
 `define R9 8'd9  
 `define RL 8'd10
 `define RH 8'd11


 `define HSYNC_BP_T 16'd47
 `define HSYNC_FP_T 16'd47
 `define HSYNC_DISP_T 16'd384000
 `define HSYNC_PULSE_T 16'd95

 `define VSYNC_BP_T 32'd23200
 `define VSYNC_FP_T 32'd8000
 `define VSYNC_DISP_T 32'd384000
 `define VSYNC_PULSE_T 32'd1600

    
`endif
