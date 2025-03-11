/*
 This module takes a 5-bit control input (`c`) and an enable bit (`en`), 
 shifting `en` left in a 32-bit output (`bitcheck`) according to the 
 specified bits in `c`. Each bit of `c` determines the number of positions 
 to shift `en`, filling the remaining bits with zeros.
 */
module bit_Verification(input [4:0] c,
					 input en,
					 output [31:0] bitcheck);
	
	wire [31:0] temp0;
	assign temp0 = {31'b0,en};
	
	wire [31:0] temp1, temp2, temp3, temp4;
	
	assign temp1 = c[0] ? {temp0[30:0],1'b0} : temp0;
	assign temp2 = c[1] ? {temp1[29:0],2'b0} : temp1;
	assign temp3 = c[2] ? {temp2[27:0],4'b0} : temp2;
	assign temp4 = c[3] ? {temp3[23:0],8'b0} : temp3;
	assign bitcheck = c[4] ? {temp4[15:0],16'b0} : temp4;
	
endmodule