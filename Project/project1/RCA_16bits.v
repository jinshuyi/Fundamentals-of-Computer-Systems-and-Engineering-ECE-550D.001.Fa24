module RCA_16bits(input [15:0] in1,
						input [15:0] in2,
						input cin,
						output cout,
						output [15:0] s);
	wire [14:0]c;
	
	// addition
	fadder add0(in1[0], in2[0], cin, c[0], s[0]);//first half adder to get the first carry
	
	
	//in order to generate a thing to count the number
	genvar i; 
	// full adders for 1 to 31 bit.
	generate 
		for(i = 1; i <= 14; i = i + 1) begin : add_loop
			fadder add1_14(in1[i], in2[i], c[i-1], c[i], s[i]);
		end
	endgenerate
	fadder add15(in1[15], in2[15], c[14], cout, s[15]);
	
endmodule