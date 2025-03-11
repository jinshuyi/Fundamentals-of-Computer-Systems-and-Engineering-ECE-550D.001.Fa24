//This Verilog full adder adds two single-bit inputs and a carry-in, producing a sum and carry-out, using XOR and AND gates to handle both bitwise addition and carry propagation.
module fulladder(a, b, cin, cout, sum); 
	input a, b, cin;
	output cout, sum;
	wire ab_xor, ab_and, abc_and;
	
	xor xorab(ab_xor, a, b);
	and andab(ab_and, a, b);
	and andabc(abc_and, ab_xor, cin);
	
	xor xor_sum(sum, ab_xor, cin);
	
	or or_cout(cout, ab_and, abc_and);
	
endmodule