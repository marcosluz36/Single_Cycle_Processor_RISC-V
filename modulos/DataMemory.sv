module DataMemory(
	input         clk,
	input         rst,
	input         WE,
	input  [31:0] A, 
	input  [31:0] WD,
	output [31:0] RD  
);

reg [31:0] MEM [0:255];

assign RD = MEM[A[31:2]];

always_ff @(posedge clk or negedge rst) begin
	if (!rst) begin
		for (int i = 0; i < 32; i++)
			MEM[i] <= 32'd0;
	end
	
	else begin
		if (WE)
			MEM[A[31:2]] <= WD;
	end
end

endmodule