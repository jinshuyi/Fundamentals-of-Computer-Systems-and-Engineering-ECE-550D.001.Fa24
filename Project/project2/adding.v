//This Verilog code creates a 32-bit adder that adds two 32-bit inputs, in1 and in2, producing a 32-bit sum s and an overflow flag. It uses two 16-bit ripple carry adders to calculate the sum of the lower and upper halves of the inputs, selecting the appropriate output based on whether there was a carry. 
//To detect overflow, it checks the sign bits of the inputs and the result, indicating overflow if the inputs have the same sign but the result does not.


module adding(input [31:0]in1,
					input [31:0]in2,
					output [31:0]s,
					output overflow);
	
	wire [1:0]co;
	wire ctemp;
	
	wire [15:0] stemp0;
	wire [15:0] stemp1;
	
	wire res31;
	wire rein1_31;
	wire rein2_31;
	
	wire [3:0]ofc;
	

	RCA_Sixteen RCA1(in1[15:0], in2[15:0], 1'b0, ctemp, s[15:0]);
	RCA_Sixteen RCA2_0(in1[31:16], in2[31:16], 1'b0, co[0], stemp0[15:0]);
	RCA_Sixteen RCA2_1(in1[31:16], in2[31:16], 1'b1, co[1], stemp1[15:0]);
	
	assign s[31:16] = ctemp ? stemp1[15:0] : stemp0[15:0];
	
	not re_s_31(res31, s[31]);
	not re_in1_31(rein1_31, in1[31]);
	not re_in2_31(rein2_31, in2[31]);
	
	and of1(ofc[0], in1[31], in2[31]);
	and of2(ofc[1], ofc[0], res31);
	and of3(ofc[2], rein1_31, rein2_31);
	and of4(ofc[3], ofc[2], s[31]);
	or ofr(overflow, ofc[1], ofc[3]);
	
endmodule