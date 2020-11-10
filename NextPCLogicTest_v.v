`timescale 1ns / 1ps
`define STRLEN 32

module NextPClogicTest_v;

	task passTest;
		input [64:0] actualOut, expectedOut;
		input [`STRLEN*8:0] testType;
		input [3:0] passed;

		if(actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end
		else $display ("%s failed: %x should be %x", testType, actualOut, expectedOut);
	endtask

	task allPassed;
		input [3:0] passed;
		input [3:0] numTests;
	 
		if(passed == numTests) $display ("All tests passed");
		else $display("All tests passed");
	endtask

	// Inputs
	reg [63:0] CurrentPC, SignExtImm64;
	reg Branch, ALUZero, Uncondbranch;
	reg [3:0] passed;

	// Outputs
	wire [63:0] NextPC;
	
	initial //This initial block used to dump all wire/reg values to dump file
     begin
      $dumpfile("NextPClogicTest_v.vcd");
      $dumpvars(0,NextPClogicTest_v);
     end

	// Instantiate the Unit Under Test (UUT)
	NextPClogic uut (
	 .CurrentPC(CurrentPC),
	 .SignExtImm64(SignExtImm64),
	 .Branch(Branch),
	 .ALUZero(ALUZero),
	 .Uncondbranch(Uncondbranch),
	 .NextPC(NextPC)
	);

	initial begin
		 // Initialize Inputs
		 CurrentPC = 0;
		 SignExtImm64 = 0;
		 ALUZero = 0;
		 Branch = 0;
		 Uncondbranch = 0;
		 passed = 0;
		 
		 //Branch 1, ALUZero 1

		 {CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'h0000000000000001, 64'h0000000000000002, 1'b1, 1'b1, 1'b0}; #40; passTest({NextPC}, 64'h0000000000000009, "Branch 1, ALUZero 1", passed);
		 #20 
		 //Branch 1, ALUZero 0
		 {CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'h0000000000000001, 64'h0000000000000002, 1'b1, 1'b0, 1'b0}; #40; passTest({NextPC}, 64'h0000000000000005, "Branch 1, ALUZero 0", passed);
		 #20 

		 //UnBranch 1, ALUZero 1
		  {CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'h0000000000000001, 64'h0000000000000002, 1'b0, 1'b1, 1'b1}; #40; passTest({NextPC}, 64'h0000000000000009, "UnBranch 1, ALUZero 1", passed);
		 #20 
			 
		 //CBZ-Type
		  {CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'h0000000000000001, 64'h0000000000000002, 1'b0, 1'b0, 1'b0}; #40; passTest({NextPC}, 64'h0000000000000005, "UnBranch 1 ALUZero 0", passed);

		   
		 allPassed(passed, 4);
	 
	end
     
endmodule

