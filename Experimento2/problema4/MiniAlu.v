
`timescale 1ns / 1ps
`include "Defintions.v"

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
wire [15:0]	 rmul1;
wire [15:0]	 rmul2;
wire [15:0]	 rmul3;
wire [15:0]	 rmul4;
wire [15:0]	 rmul5;
wire [15:0]	 rmul6;
wire [15:0]	 rmul7;
wire [15:0]	 rmul8;	
reg [31:0] 	 TempMul;

wire [7:0]  wSourceAddr0,wSourceAddr1,wDestination;
wire  [15:0] wSourceData0,wSourceData1,wIPInitialValue,wImmediateValue;

wire signed [15:0] wSourceData0m,wSourceData1m;

 assign wSourceData0m = wSourceData0;
 assign wSourceData1m = wSourceData1;

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

MUX # ( 16 ) mux1
		(
			.Clock(Clock),
			.in0(16'h0000),
			.in1( wSourceData0 ),
			.in2( {wSourceData0,1'b0} ),
			.in3( {wSourceData0,1'b0} + wSourceData0 ),
			.select( wSourceData1[1:0] ),
			.out( rmul1 )
		);
wire [31:0] prueba1 = rmul1;

MUX # ( 16 ) mux2
		(
			.Clock(Clock),
			.in0(16'h0000),
			.in1( wSourceData0 ),
			.in2( {wSourceData0,1'b0} ),
			.in3( {wSourceData0,1'b0} + wSourceData0 ),
			.select( wSourceData1[3:2] ),
			.out( rmul2 )
		);

wire [31:0] prueba2 = {rmul2,2'b00};

MUX # ( 16 ) mux3
		(
			.Clock(Clock),
			.in0(16'h0000),
			.in1( wSourceData0 ),
			.in2( {wSourceData0,1'b0} ),
			.in3( {wSourceData0,1'b0} + wSourceData0 ),
			.select( wSourceData1[5:4] ),
			.out( rmul3 )
		);
wire [31:0] prueba3 = {rmul3,4'b0000};

MUX # ( 16 ) mux4
		(
			.Clock(Clock),
			.in0(16'h0000),
			.in1( wSourceData0 ),
			.in2( {wSourceData0,1'b0} ),
			.in3( {wSourceData0,1'b0} + wSourceData0 ),
			.select( wSourceData1[7:6] ),
			.out( rmul4 )
		);

wire [31:0] prueba4 = {rmul4,6'b000000};

MUX # ( 16 ) mux5
		(
			.Clock(Clock),
			.in0(16'h0000),
			.in1( wSourceData0 ),
			.in2( {wSourceData0,1'b0} ),
			.in3( {wSourceData0,1'b0} + wSourceData0 ),
			.select( wSourceData1[9:8] ),
			.out( rmul5 )
		);
wire [31:0] prueba5 = {rmul5,8'b00000000};

MUX # ( 16 ) mux6
		(
			.Clock(Clock),
			.in0(16'h0000),
			.in1( wSourceData0 ),
			.in2( {wSourceData0,1'b0} ),
			.in3( {wSourceData0,1'b0} + wSourceData0 ),
			.select( wSourceData1[11:10] ),
			.out( rmul6 )
		);

wire [31:0] prueba6 = {rmul6,10'b0000000000};

MUX # ( 16 ) mux7
		(
			.Clock(Clock),
			.in0(16'h0000),
			.in1( wSourceData0 ),
			.in2( {wSourceData0,1'b0} ),
			.in3( {wSourceData0,1'b0} + wSourceData0 ),
			.select( wSourceData1[13:12] ),
			.out( rmul7 )
		);
wire [31:0] prueba7 = {rmul7,12'b000000000000};

MUX # ( 16 ) mux8
		(
			.Clock(Clock),
			.in0(16'h0000),
			.in1( wSourceData0 ),
			.in2( {wSourceData0,1'b0} ),
			.in3( {wSourceData0,1'b0} + wSourceData0 ),
			.select( wSourceData1[15:14] ),
			.out( rmul8 )
		);

wire [31:0] prueba8 = {rmul8,14'b00000000000000};

wire [31:0] final1 = prueba1 + prueba2;
wire [31:0] final2 = prueba3 + prueba4;
wire [31:0] final3 = prueba5 + prueba6;
wire [31:0] final4 = prueba7 + prueba8;

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
	`MUL2:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b1;
		rMulEnable   <= 1'b1;
		TempMul      <= final1+final2+final3+final4;
		rResult      <= TempMul[15:0];
		rResultMul   <= TempMul[31:16];
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
