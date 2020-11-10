`timescale 1ns / 1ps

module NextPClogic(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch); 
	input [63:0] CurrentPC, SignExtImm64; 
	input Branch, ALUZero, Uncondbranch; 
	output reg [63:0] NextPC; 

	always @(*)
		begin #1
			if(Uncondbranch == 1 || (Branch && ALUZero))
				NextPC <= #2 CurrentPC + (SignExtImm64 << 2);
			else
				NextPC <= #1 CurrentPC + 4;
		end
endmodule

