
`timescale 1ns / 1ps
`include "Definitions.v"
//`include "Collaterals.v"

module MiniAlu
(
 input wire Clock,
 input wire Reset,
 input wire PS2_CLK,
 input wire PS2_DATA,
 output wire [7:0] oLed,
 //output wire [4:0] oVGA
 output wire VGA_RED, VGA_GREEN, VGA_BLUE, VGA_HSYNC, VGA_VSYNC
);

wire [15:0]  wIP,wIP_temp;
reg         rWriteEnable, rMulEnable, rBranchTaken;
wire [27:0] wInstruction;
wire [3:0]  wOperation;
reg [15:0]   rResult;

wire [7:0]  wSourceAddr0, wSourceAddr1, wDestination;
wire [15:0] wSourceData0, wSourceData1, wIPInitialValue, wImmediateValue;

//*************************Laboratorio 4: VGA************************************************************
reg rVGAWriteEnable;
wire wVGA_R, wVGA_G, wVGA_B;
wire [9:0] wH_counter,wV_counter;
wire [7:0] wH_read, wV_read;
assign wH_read = (wH_counter >= 240 && wH_counter <= 496) ? (wH_counter - 240) : 8'd0;
assign wV_read = (wV_counter >= 141 && wV_counter <= 397) ? (wV_counter - 141) : 8'd0;

reg rRetCall;
reg [7:0] rDirectionBuffer;
wire [7:0] wRetCall;
wire [7:0] wXRedCounter, wYRedCounter;
wire [3:0] color_reg;

// Definición del clock de 25 MHz
wire slow_clock; // Clock con frecuencia de 25 MHz

reg rflag;
reg Reset_clock;
always @ (posedge Clock)
begin
	if (rflag) begin
		Reset_clock <= 0;
	end
	else begin
		Reset_clock <= 1;
		rflag <= 1;
	end
end

// Instancia para crear el clock lento
wire wClock_counter;
assign slow_clock = wClock_counter;
UPCOUNTER_POSEDGE # ( 1 ) Slow_clock
(
.Clock(   Clock                ),
.Reset(   Reset_clock ),
.Initial( 1'd0 ),
.Enable(  1'b1                 ),
.Q(       wClock_counter             )
);
// Fin de la implementación del reloj lento

// Instancia del controlador de VGA
VGA_controller VGA_controlador
(
	.slow_clock(slow_clock),
	.Reset(Reset),
	.iXRedCounter(wXRedCounter),
	.iYRedCounter(wYRedCounter),
	.iVGA_RGB({wVGA_R,wVGA_G,wVGA_B}),
	.iColorCuadro(color_reg),
	.oVGA_RGB({VGA_RED, VGA_GREEN, VGA_BLUE}),
	.oHsync(VGA_HSYNC),
	.oVsync(VGA_VSYNC),
	.oVcounter(wV_counter),
	.oHcounter(wH_counter)
);
reg [7:0] Filter;
reg FClock;
always @ (posedge slow_clock) begin
	Filter <= {PS2_CLK, Filter[7:1]};
	if (Filter == 8'hFF) FClock = 1'b1;
	if (Filter == 8'd0) FClock = 1'b0;
end

reg [7:0] FilterData;
reg FData;
always @ (posedge slow_clock) begin
	FilterData <= {PS2_DATA, FilterData[7:1]};
	if (FilterData == 8'hFF) FData = 1'b1;
	if (FilterData == 8'd0) FData = 1'b0;
end

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
	.oDataOut1(     wSourceData1 )
//	.iMulEnable(	 rMulEnable   ),
//	.iDataInMul(    rResultMul   )// conectar este registro a la RAM y asignarlo al registro no.9 de la RAM
);

UPCOUNTER_POSEDGE IP
(
.Clock(   Clock                ),
.Reset(   Reset | rBranchTaken ),
.Initial( wIPInitialValue + 1  ),
.Enable(  1'b1                 ),
.Q(       wIP_temp             )
);

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

//---------------------------
//-------- Teclado y VRAM ---
//---------------------------

keyboard keyboard
(
	.Reset(Reset),
	.PS2_CLK(FClock),
	.PS2_DATA(FData),
	.ColorReg(color_reg),
	.XRedCounter(wXRedCounter),
	.YRedCounter(wYRedCounter)
);

// Instancia RAM para contenido de pantalla
RAM_SINGLE_READ_PORT # (3,16,65535) VideoMemory
(
	.Clock(Clock),
	.iWriteEnable( rVGAWriteEnable ),
	.iReadAddress( {wH_read,wV_read} ), // Columna, fila
	.iWriteAddress( {wSourceData1[7:0],wSourceData0[7:0]} ), // Columna, fila
	.iDataIn(wDestination[2:0]),
	.oDataOut( {wVGA_R,wVGA_G,wVGA_B} )
);

always @ (posedge Clock)
begin
	if (wOperation == `CALL)
		rDirectionBuffer <= wIP_temp;
end

assign wIP = (rBranchTaken) ? wIPInitialValue : wIP_temp;
assign wIPInitialValue = (Reset) ? 8'b0 : wRetCall;
assign wRetCall = (rRetCall) ? rDirectionBuffer : wDestination;

//===========================
// Switch-case para instrucciones
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
    rVGAWriteEnable <= 1'b0; // agregada por la creación de la VRAM
    rRetCall <= 1'b0; // agregada por la creación de la VRAM
	end
	//-------------------------------------
	`ADD:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult      <= wSourceData1 + wSourceData0;
    rVGAWriteEnable <= 1'b0;
    rRetCall <= 1'b0;
	end
	//-------------------------------------
	`SUB:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult      <= wSourceData1 - wSourceData0;
    rVGAWriteEnable <= 1'b0;
    rRetCall <= 1'b0;
	end
	//-------------------------------------
	`STO:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b1;
		rBranchTaken <= 1'b0;
		rResult      <= wImmediateValue;
    rVGAWriteEnable <= 1'b0;
    rRetCall <= 1'b0;
	end
	//-------------------------------------
  `BGE:
	begin
		rFFLedEN     <= 1'b0;
		rVGAWriteEnable <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 16'b0;
		rRetCall <= 1'b0;
		if (wSourceData1 >= wSourceData0 )
			rBranchTaken <= 1'b1;
		else
			rBranchTaken <= 1'b0;
	end
  //-------------------------------------
	`BLE:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 16'b0;
    rVGAWriteEnable <= 1'b0;
    rRetCall <= 1'b0;
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
		rResult      <= 16'b0;
		rBranchTaken <= 1'b1;
    rVGAWriteEnable <= 1'b0;
    rRetCall <= 1'b0;
	end
	//-------------------------------------
	// `LED:
	// begin
	// 	rFFLedEN     <= 1'b1;
	// 	rWriteEnable <= 1'b0;
	// 	rResult      <= 0;
	// 	rBranchTaken <= 1'b0;
  //   rVGAWriteEnable <= 1'b0;
  //   rRetCall <= 1'b0;
	// end
	//-------------------------------------
	/* Instruccin para multiplicacion de dos numeros de 16 bits
	modificando la RAM, parte 1 del laboratorio
	*/
	// `SMUL:
	// begin
	// 	rFFLedEN     <= 1'b1;
	// 	rWriteEnable <= 1'b1;
	// 	rMulEnable   <= 1'b1;
	// 	TempMul      <= wSourceData1m * wSourceData0m;
	// 	rResult      <= 16'h0000;
	// 	rResultMul   <= 16'h0000;
	// 	rResult      <= TempMul[15:0];
	// 	rResultMul   <= TempMul[31:16];
	// 	rBranchTaken <= 1'b0;
  //   rVGAWriteEnable <= 1'b0;
  //   rRetCall <= 1'b0;
	// end

	//-------------------------------------
	// `MUL2:
	// begin
	// 	rFFLedEN     <= 1'b1;
	// 	rWriteEnable <= 1'b1;
	// 	rMulEnable   <= 1'b1;
	// 	TempMul      <= final1+final2+final3+final4;
	// 	rResult      <= TempMul[15:0];
	// 	rResultMul   <= TempMul[31:16];
	// 	rBranchTaken <= 1'b0;
  //   rVGAWriteEnable <= 1'b0;
  //   rRetCall <= 1'b0;
	// end
	//-------------------------------------

	// para multiplicador de 4bits
	// `MUL4bits:
	// begin
	// 	rFFLedEN     <= 1'b1;
	// 	rWriteEnable <= 1'b1;
	// 	rMulEnable   <= 1'b1;
  //
	// 	rResultMul   <= rResultMul4bits;
	// 	rBranchTaken <= 1'b0;
  //   rVGAWriteEnable <= 1'b0;
  //   rRetCall <= 1'b0;
	// end

	    //-------------------------------------
	`VGA:
	 begin
		 rFFLedEN     <= 1'b0;
		 rBranchTaken <= 1'b0;
		 rWriteEnable <= 1'b0;
		 rResult      <= 16'b0;
     rVGAWriteEnable <= 1'b1;
     rRetCall <= 1'b0;
	 end
//-------------------------------------
  `RET:
  begin
    rVGAWriteEnable <= 1'b0;
    rWriteEnable <= 1'b0;
    rResult      <= 16'b0;
    rBranchTaken <= 1'b1;
    rRetCall <= 1'b1;
	 rFFLedEN     <= 1'b0;
  end
	//-------------------------------------
  `CALL:
  begin
    rVGAWriteEnable <= 1'b0;
    rWriteEnable <= 1'b0;
    rResult      <= 16'b0;
    rBranchTaken <= 1'b1;
    rRetCall <= 1'b0;
	 rFFLedEN     <= 1'b0;
  end
//-----------------------------------
	default:
	begin
	rFFLedEN     <= 1'b0;
 	rWriteEnable <= 1'b0;
  	 rResult      <= 16'b0;
	 rBranchTaken <= 1'b0;
    rVGAWriteEnable <= 1'b0;
    rRetCall <= 1'b0;
	end
	//-------------------------------------
	endcase
end


endmodule
