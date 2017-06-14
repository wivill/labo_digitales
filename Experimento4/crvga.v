`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:18:44 09/28/2016 
// Design Name: 
// Module Name:    crvga 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description:  
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module crvga(
	input wire clock,
	input wire reset,
	input wire iCrvgaR,iCrvgaG,iCrvgaB,
	output reg oCrvgaR,oCrvgaG,oCrvgaB,
	output reg ver_sync, hoz_sync,
	output reg 	[7:0] oCurrentCol,
	output reg 	[7:0] oCurrentRow
    );

	reg vga_clock;
	
	initial
		begin
		vga_clock=0;
		end
		
	reg next_row;
	wire en_col_counter;
	reg reset_col;
	reg reset_row;
	wire [10:0] row;
	wire [10:0] col; 
	assign en_col_counter=1;
	
	always @(posedge clock)
	begin
		if(reset)
		begin
			reset_col<=1;
			reset_row<=1;
			next_row<=0;
			hoz_sync<=1;
			ver_sync<=1;
		end
				
		else
			begin
			
			/*
			
			HORIZONTAL SYNC TIMING
			+-----+-----+--------------------------------------+-----+
			| 96 	| 48 	| 						640						| 16 	|
			|		|		+--------+--------------------+--------+		|
			|		|		|	192	|			256			|  192	|		|
			+-----+-----+--------+--------------------+--------+-----+
			|	hs	|	bp	|				total display					|	fp	|
			+-----+-----+--------+--------------------+--------+-----+
			|		no color			| 	effective display	|	no color		|
			+--------------------------------------------------------+
			|		|		|			|							|			|		|
			0		96		144		336						592		784	800
			
			
			VERTICAL SYNC TIMING
			+-----+--------------------------------------+-----+-----+
			| 29 	| 						480						| 10 	|	2	|
			|		+--------+--------------------+--------+		|		|
			|		|	112	|			256			|  112	|		|		|
			+-----+--------+--------------------+--------+-----+-----+
			|	bp	|				total display					|	fp	|	vs	|
			+-----+--------+--------------------+--------+-----+-----+
			|		no color	| 	effective display	|		no color			|
			+--------------------------------------------------------+
			|		|			|							|			|		|		|
			0		29			141						397		509	519	521
	
			*/
			
			//set RGB
			if((336<=col)&(col<592)&(141<=row)&(row<397))
				begin
				//set color
				oCrvgaR 	<= 	iCrvgaR;
				oCrvgaG 	<= 	iCrvgaG;
				oCrvgaB 	<=		iCrvgaB;
				end
			else
				begin
				//no color
				oCrvgaR 	<= 	1'b0;
				oCrvgaG 	<= 	1'b0;
				oCrvgaB 	<=		1'b0;
				end
			
			//horizonal sync low pulse
			if(col<96)
				hoz_sync <=		0;
			else
				hoz_sync <=		1;
				
			//reset column counter, and go next row
			if (col>=799)
				begin
				reset_col 	<= 	1'b1;
				next_row 	<=		1'b1;
				end
			else
				begin
				reset_col 	<=		1'b0;
				next_row		<=		1'b0;
				end
							
			//vertical sync low pulse
			if((519<=row)&(row<=520))
				ver_sync 	<=		1'b0;
			else
				ver_sync		<= 	1'b1;
			
			//reset row counter
			if(520<row)
				reset_row 	<=		1'b1;
			else 
				reset_row 	<=		1'b0;
			end
		
		// row index from [0,256]
		if((row<=141)|(397<row))
			oCurrentRow<=0;
		else
			oCurrentRow<=row-141;
		
		// column index from [0,256]
		if((col<=336)|(592<col))
			oCurrentCol<=0;
		else
			oCurrentCol<=col-336;
	end
	
	// column counter instance
	upcounter #(11) colcounter
	(
		.clock(vga_clock),
		.reset(reset_col),
		.enable(en_col_counter),
		.oResult(col)		
	);
	
	// row counter instance
	upcounter #(11) rowcounter 
	(
		.clock(vga_clock),
		.reset(reset_row),
		.enable(next_row),
		.oResult(row)
	);
	
	// divides frequency by 2, 25MHz
	always @(posedge clock)
	begin
		vga_clock <= ~vga_clock;
	end

endmodule
