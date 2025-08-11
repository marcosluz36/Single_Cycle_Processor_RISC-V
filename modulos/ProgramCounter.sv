module ProgramCounter(
	input             clk,
	input             rst,
	input      [31:0] PCin,
	output reg [31:0] PC
);

always_ff @(posedge clk or negedge rst) begin
	if (!rst)
		PC <= 32'd0; 
		
	else
		PC <= PCin; 

end

endmodule