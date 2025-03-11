module addition(input [31:0]in1,
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
	
	//CSA
	RCA_16bits RCA1(in1[15:0], in2[15:0], 1'b0, ctemp, s[15:0]);
	RCA_16bits RCA2_0(in1[31:16], in2[31:16], 1'b0, co[0], stemp0[15:0]);
	RCA_16bits RCA2_1(in1[31:16], in2[31:16], 1'b1, co[1], stemp1[15:0]);
	
	assign s[31:16] = ctemp ? stemp1[15:0] : stemp0[15:0];
	
	//check adder overflow = in1[31]&in2[31]&sreverse[31] + in1reverse[31]&in2reverse[31]&s[31]
	not re_s_31(res31, s[31]);
	not re_in1_31(rein1_31, in1[31]);
	not re_in2_31(rein2_31, in2[31]);
	
	and of1(ofc[0], in1[31], in2[31]);
	and of2(ofc[1], ofc[0], res31);
	and of3(ofc[2], rein1_31, rein2_31);
	and of4(ofc[3], ofc[2], s[31]);
	or ofr(overflow, ofc[1], ofc[3]);
	
endmodule