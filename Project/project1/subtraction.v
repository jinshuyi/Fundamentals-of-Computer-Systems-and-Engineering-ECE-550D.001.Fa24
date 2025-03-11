module subtraction(input [31:0]in1,
						input [31:0]in2,
						output [31:0]s,
						output overflow);
	
	wire [31:0]re2;
	
	wire [1:0]co;
	wire ctemp;
	
	wire [15:0] stemp0;
	wire [15:0] stemp1;
	
	wire res31;
	wire rein1_31;
	
	wire [3:0]ofc;
	
	
	// reverse in2
	genvar i; //generate counter
	generate // full adders for 1 to 31 bit.
		for(i = 0; i <= 31; i = i + 1) begin : sub_loop
			not res_in2(re2[i], in2[i]);//reverse input2
		end
	endgenerate
	
	//CSA
	RCA_16bits RCA1(in1[15:0], re2[15:0], 1'b1, ctemp, s[15:0]);
	RCA_16bits RCA2_0(in1[31:16], re2[31:16], 1'b0, co[0], stemp0[15:0]);
	RCA_16bits RCA2_1(in1[31:16], re2[31:16], 1'b1, co[1], stemp1[15:0]);
	
	assign s[31:16] = ctemp ? stemp1[15:0] : stemp0[15:0];
	
	//checkoverflow 
	not re_s_31(res31, s[31]);
	not re_in1_31(rein1_31, in1[31]);
	
	and of1(ofc[0], in1[31], re2[31]);
	and of2(ofc[1], ofc[0], res31);
	and of3(ofc[2], rein1_31, in2[31]);
	and of4(ofc[3], ofc[2], s[31]);
	or ofr(overflow, ofc[1], ofc[3]);
	
endmodule