`timescale 1ns / 1ps
`ifndef DEFINTIONS_V
`define DEFINTIONS_V
	
/*`default_nettype none	
`define NOP   4'd0
`define LED   4'd2
`define BLE   4'd3
`define STO   4'd4
`define ADD   4'd5
`define JMP   4'd6
`define SUB   4'd7*/

`default_nettype none	
`define NOP   4'b0000
`define LED   4'b0010
`define BLE   4'b0011
`define STO   4'b0100
`define ADD   4'b0101
`define JMP   4'b0110
`define SUB   4'b0111

/*`define R0 8'd0
`define R1 8'd1
`define R2 8'd2
`define R3 8'd3
`define R4 8'd4
`define R5 8'd5
`define R6 8'd6
`define R7 8'd7*/

`define R0 8'b0000000
`define R1 8'b0000001
`define R2 8'b0000010
`define R3 8'b0000011
`define R4 8'b0000100
`define R5 8'b0000101
`define R6 8'b0000110
`define R7 8'b0000111

`endif
