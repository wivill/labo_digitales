
`timescale 1ns / 1ps
`include "Defintions.v"
`include "labdigitales.v"


module MiniAlu
(
 input wire Clock,
 input wire Reset,
 output wire [7:0] oLed
 
);

wire [15:0]  wIP,wIP_temp;
reg         rWriteEnable, rMulEnable, rBranchTaken;
wire [27:0] wInstruction;
wire [3:0]  wOperation;
reg [15:0]   rResult;
reg [15:0] 	 rResultMul;
reg [31:0] 	 TempMul;

wire [7:0]  wSourceAddr0,wSourceAddr1,wDestination;
wire  [15:0] wSourceData0,wSourceData1,wIPInitialValue,wImmediateValue;

// prueba de 4 bits // el que dice prueba es para el de 4 bits 
wire  [3:0] wSourceData0Prueba,wSourceData1Prueba

wire signed [15:0] wSourceData0m,wSourceData1m;

// prueba de 4bits 
wire signed [3:0] wSourceData0mPrueba,wSourceData1mPrueba;

 assign wSourceData0m = wSourceData0;
 assign wSourceData1m = wSourceData1;
 
 // prueba de 4 bits
 
 assign wSourceData0mPrueba = wSourceData0Prueba;
 assign wSourceData1mPrueba = wSourceData1Prueba;
 
 // prueba de 4 bits, para resultado 
 reg [7:0] 	 rResultMul4bits;
 
 

ROM InstructionRom 
(
	.iAddress(     wIP          ),
	.oInstruction( wInstruction )
);

RAM_DUAL_READ_PORT DataRam
(
	.Clock(         Clock        ),
	.iWriteEnable(  rWriteEnable ),
	.iReadAddress0( wInstruction[7:0] ),
	.iReadAddress1( wInstruction[15:8] ),
	.iWriteAddress( wDestination ),
	.iDataIn(       rResult      ),
	.oDataOut0(     wSourceData0 ),
	.oDataOut1(     wSourceData1 ),
	.iMulEnable(	 rMulEnable   ),
	.iDataInMul(    rResultMul   )
);

// prueba de 4bits

mul4bits
(
	.A(         wSourceData0Prueba       ),
	.B(  wSourceData1Prueba ),
	.wResult( rResultMul4bits )
	
);

assign wIPInitialValue = (Reset) ? 8'b0 : wDestination;
UPCOUNTER_POSEDGE IP
(
.Clock(   Clock                ), 
.Reset(   Reset | rBranchTaken ),
.Initial( wIPInitialValue + 1  ),
.Enable(  1'b1                 ),
.Q(       wIP_temp             )
);
assign wIP = (rBranchTaken) ? wIPInitialValue : wIP_temp;

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD1 
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[27:24]),
	.Q(wOperation)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD2
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[7:0]),
	.Q(wSourceAddr0)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD3
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[15:8]),
	.Q(wSourceAddr1)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD4
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[23:16]),
	.Q(wDestination)
);


reg rFFLedEN;
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FF_LEDS
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable( rFFLedEN ),
	.D( wSourceData1 ),
	.Q( oLed    )
);

assign wImmediateValue = {wSourceAddr1,wSourceAddr0};



always @ ( * )
begin
	case (wOperation)
	//-------------------------------------
	`NOP:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
	end
	//-------------------------------------
	`ADD:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult      <= wSourceData1 + wSourceData0;
	end
	//-------------------------------------
	`SUB:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult      <= wSourceData1 - wSourceData0;
	end
	//-------------------------------------
	`STO:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b1;
		rBranchTaken <= 1'b0;
		rResult      <= wImmediateValue;
	end
	//-------------------------------------
	`BLE:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		if (wSourceData1 <= wSourceData0 )
			rBranchTaken <= 1'b1;
		else
			rBranchTaken <= 1'b0;
		
	end
	//-------------------------------------	
	`JMP:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b1;
	end
	//-------------------------------------	
	`LED:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
	end
	//-------------------------------------
	`SMUL:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b1;
		rMulEnable   <= 1'b1;
		TempMul      <= wSourceData1m * wSourceData0m;
		rResult      <= TempMul[15:0];
		rResultMul   <= TempMul[31:16];
		rBranchTaken <= 1'b0;
	end
	
	//-------------------------------------
	// para multiplicador de 4bits
	`MUL4bits:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b1;
		rMulEnable   <= 1'b1;
		//TempMul      <= wSourceData1m * wSourceData0m;
		//rResult      <= TempMul[15:0];
		rResultMul   <= rResultMul4bits;
		rBranchTaken <= 1'b0;
	end
	//-------------------------------------
	default:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
	end	
	//-------------------------------------	
	endcase	
end


endmodule
