module RegisterFile_TB;

logic       clk, rst, we3;
logic [2:0] wa3, ra1, ra2;
logic [7:0] wd3, rd1, rd2;

RegisterFile rf0(
	.clk(clk), .rst(rst), .we3(we3),
	.wa3(wa3), .ra1(ra1), .ra2(ra2),
	.wd3(wd3), .rd1(rd1), .rd2(rd2)
);

initial begin
	clk = 1'b0; rst = 1'b0; we3 = 1'b0; 
	wd3 = 8'h7; wa3 = 3'd2; ra1 = 3'd2; ra2 = 3'd5; #3;
	
	rst = 1'b1; we3 = 1'b1; #4 
	
	wa3 = 3'd1; wd3 = 8'hCA; ra1 = 3'd0; ra2 = 3'd1; #9;
	wa3 = 3'd7; wd3 = 8'hFE; ra1 = 3'd7; ra2 = 3'd2; #12;
	
	we3 = 1'b0; #6;
	wa3 = 3'd2; wd3 = 8'h34; ra1 = 3'd2; ra2 = 3'd4; #10;
	we3 = 1'b1; #5;
	
	wa3 = 3'd0; wd3 = 8'hDB; ra1 = 3'd3; ra2 = 3'd0; #13;
	wa3 = 3'd5; wd3 = 8'h29; ra1 = 3'd5; ra2 = 3'd2; #14;
end

always begin
	#5; clk = ~clk;
end


endmodule