///This Verilog code defines a 32-bit logical left shift module that shifts the input in left based on a 5-bit control signal example, which specifies how many positions to shift. 
//The output out is computed by conditionally applying shifts in stages, allowing for efficient shifting by up to 16 bits.

module SLL_Left(input [31:0] in,
				input [4:0] example,
				output [31:0] out);
	
	wire [31:0] temp0, temp1, temp2, temp3;
	
	assign temp0 = example[0] ? {in[30:0],1'b0} : in;
	assign temp1 = example[1] ? {temp0[29:0],2'b0} : temp0;
	assign temp2 = example[2] ? {temp1[27:0],4'b0} : temp1;
	assign temp3 = example[3] ? {temp2[23:0],8'b0} : temp2;
	assign out = example[4] ? {temp3[15:0],16'b0} : temp3;
	
endmodule