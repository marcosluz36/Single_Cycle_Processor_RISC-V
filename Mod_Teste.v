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

wire [7:0] wd3 = SW[7:0];

assign LEDG[8] = ~KEY[1];

RegisterFile(
	.clk(KEY[0]),    .rst(KEY[2]),    .we3(SW[17]),
	.wa3(SW[16:14]), .ra1(SW[13:11]), .ra2(SW[10:8]),
	.wd3(wd3),       .rd1(w_d0x0),    .rd2(w_d0x1)
);

Hex7Seg decode_hex0(
	.in(wd3[3:0]),
	.out(HEX0)
);

Hex7Seg decode_hex1(
	.in(wd3[7:4]),
	.out(HEX1)
);

endmodule
