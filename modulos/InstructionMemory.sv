module InstructionMemory(
	input  [31:0] A,
	output [31:0] RD
);

reg [31:0] ROM [0:255];

initial
	$readmemh("../machine_code/sprint_08.txt", ROM); 

assign RD = ROM[A[31:2]];

endmodule