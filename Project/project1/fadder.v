//The full adder just as used in RC3
module fadder(a, b, cin, cout, sum); 
	input a, b, cin;
	output cout, sum;
	wire ab_xor, ab_and, abc_and;
	
	xor xorab(ab_xor, a, b);
	and andab(ab_and, a, b);
	and andabc(abc_and, ab_xor, cin);
	
	xor xor_sum(sum, ab_xor, cin);
	or or_cout(cout, ab_and, abc_and);
	
endmodule