//This Verilog code defines a 32-bit bitwise OR operation module that takes two 32-bit inputs, in1 and in2, and produces a 32-bit output result,
// where each bit is the logical OR of the corresponding bits from in1 and in2. 
//The generate block creates individual OR gates for each bit from 0 to 31.

module OR_Operation(input [31:0] in1,
					input [31:0] in2,
					output [31:0] result);
	genvar i; //generate counter
	generate 
		for(i = 0; i <= 31; i = i + 1) begin : or_loop
			or or0_31(result[i], in1[i], in2[i]);
		end
	endgenerate
endmodule