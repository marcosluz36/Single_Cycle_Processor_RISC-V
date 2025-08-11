`default_nettype none 

module Mod_Teste (
	input CLOCK_27, CLOCK_50,                                    // Clocks
	input [3:0] KEY,                                             // Botoes
	input [17:0] SW,                                             // Chaves
	output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, // Displays de 7-SEG
	output [8:0] LEDG,                                           // LEDs Verdes
	output [17:0] LEDR,                                          // LEDs Vermelhos 
	output UART_TXD,                                             // Serial Transfer
	input UART_RXD,                                              // Serial Receiver
	inout [7:0] LCD_DATA,                                        // Entrada/Saida de dados do LCD
	output LCD_ON, LCD_BLON, LCD_RW, LCD_EN, LCD_RS,             // Estados do LCD
	inout [35:0] GPIO_0, GPIO_1                                  // Entrada/Saida de uso Geral
);

assign GPIO_1 = 36'hzzzzzzzzz;
assign GPIO_0 = 36'hzzzzzzzzz;
assign LCD_ON = 1'b1;
assign LCD_BLON = 1'b1;

wire [7:0] w_d0x0, w_d0x1, w_d0x2, w_d0x3, w_d0x4, w_d0x5,
			  w_d1x0, w_d1x1, w_d1x2, w_d1x3, w_d1x4, w_d1x5;

LCD_TEST MyLCD (
	.iCLK(CLOCK_50),
	.iRST_N(KEY[0]),
	.d0x0(w_d0x0),.d0x1(w_d0x1),.d0x2(w_d0x2),.d0x3(w_d0x3),
	.d0x4(w_d0x4),.d0x5(w_d0x5),.d1x0(w_d1x0),.d1x1(w_d1x1),
	.d1x2(w_d1x2),.d1x3(w_d1x3),.d1x4(w_d1x4),.d1x5(w_d1x5),
	.LCD_DATA(LCD_DATA),
	.LCD_RW(LCD_RW),
	.LCD_EN(LCD_EN),
	.LCD_RS(LCD_RS)
);
	
//---------- modifique a partir daqui --------

wire clk, rst;

wire w_ResultSrc, w_MemWrite, w_ULAControl, 
     w_ULASrc,    w_RegWrite, w_PCSrc,     
	  w_Zero,      w_Branch;
	  
wire [1:0] w_ImmSrc;
	  
wire [11:0] w_MImm;
	  
wire [31:0] w_PCp4,  w_rd1SrcA,   w_Inst,
            w_PC,    w_SrcB,      w_Imm,   
				w_Wd3,   w_ULAResult, w_rd2,
				w_RData, w_ImmPC,     w_PCn;

assign rst = KEY[2];

assign w_PCp4  = w_PC + 3'h4;
assign w_ImmPC = w_Imm + w_PC;
assign w_PCSrc = w_Branch & w_Zero;

assign w_d0x4  = w_PC[7:0];
assign LEDG[8] = w_PCSrc;

ClockDivider clk_1hz(
	.clk_50(CLOCK_50), 
	.rst(rst),
	.clk(clk)
);

Mux_2x1 #(32) MuxPCSrc(
	.i0(w_PCp4),  .sel(w_ULASrc),
	.i1(w_ImmPC), .out(w_PCn)
);

ProgramCounter PC(
	.clk(clk),    .rst(rst),
	.PCin(w_PCn), .PC(w_PC)
);

InstructionMemory InstMem(
	.A(w_PC),  
	.RD(w_Inst)
); 

ControlUnit CtrlUnit(
	.Op(w_Inst[6:0]),     .ResultSrc(w_ResultSrc),   .MemWrite(w_MemWrite), 
	.Funct3(w_Inst[2:0]), .ULAControl(w_ULAControl), .RegWrite(w_RegWrite),
	.Funct7(w_Inst[6:0]), .ImmSrc(w_ImmSrc),         .ULASrc(w_ULASrc)
);

RegisterFile RF(
	.clk(clk),          .rst(rst),           .we3(w_RegWrite),
	.wa3(w_Inst[11:7]), .ra1(w_Inst[19:15]), .ra2(w_Inst[24:20]),
	.wd3(w_Wd3),        .rd1(w_rd1SrcA),     .rd2(w_rd2),
	.x0(w_d0x0),        .x1(w_d0x1),         .x2(w_d0x2),    
	.x3(w_d0x3),        .x4(w_d1x0),         .x5(w_d1x1),        
	.x6(w_d1x2),        .x7(w_d1x3)
);

ExtendUnit Extend(
	.imm(w_Inst[31:7]), 
	.immSrc(w_ImmSrc),
	.immExt(w_Imm) 
);

Mux_2x1 #(32) MuxULASrc(
	.i0(w_rd2), .sel(w_ULASrc),
	.i1(w_Imm), .out(w_SrcB)
);

ULA ULA(
	.srcA(w_rd1SrcA),  .control(w_ULAControl),        
	.srcB(w_SrcB),     .result(w_ULAResult),
	.z(w_Zero)
);

DataMemory DataMem(
	.clk(clk), .A(w_ULAResult), .WD(w_rd2),      
	.rst(rst), .WE(w_MemWrite), .RD(w_RData)
	
);

Mux_2x1 #(32) MuxResSrc(
	.i0(w_ULAResult), .sel(w_ResultSrc),
	.i1(w_RData),     .out(w_Wd3)
);

Hex7Seg DecodeHEX7(.in(w_Inst[31:28]),.out(HEX7));
Hex7Seg DecodeHEX6(.in(w_Inst[27:24]),.out(HEX6));

Hex7Seg DecodeHEX5(.in(w_Inst[23:20]),.out(HEX5));
Hex7Seg DecodeHEX4(.in(w_Inst[19:16]),.out(HEX4));

Hex7Seg DecodeHEX3(.in(w_Inst[15:12]),.out(HEX3));
Hex7Seg DecodeHEX2(.in(w_Inst[11:8]),.out(HEX2));
Hex7Seg DecodeHEX1(.in(w_Inst[7:4]),.out(HEX1));
Hex7Seg DecodeHEX0(.in(w_Inst[3:0]),.out(HEX0));

endmodule
