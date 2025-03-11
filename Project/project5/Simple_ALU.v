module alu(data_operandA, data_operandB, ctrl_ALUopcode,
ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
input [31:0] data_operandA, data_operandB;
input [4:0] ctrl_ALUopcode, ctrl_shiftamt;
output [31:0] data_result;
output isNotEqual, isLessThan, overflow;

wire [31:0] subtraction;
wire subtractionoverflow;
csa sub(data_operandA,data_operandB,5'b00001,subtraction,subtractionoverflow);
wire isLessThanisoverflow;
wire isLessThannooverflow;
assign isLessThannooverflow = subtraction[31] ? 1'b1 : 1'b0;
xor (isLessThanisoverflow, subtraction[31],subtractionoverflow);
assign isLessThan = overflow ? isLessThanisoverflow :isLessThannooverflow; 

wire [31:0] subtractionzero;
wire subzeroover;
csa subzero(32'b0,subtraction,5'b00001,subtractionzero,subzeroover);
assign isNotEqual = isLessThan ? 1'b1 : subtractionzero[31];

wire [31:0]sum_result;
csa sumoperation(data_oprandA,data_operandB,ctrl_ALUopcode,sum_result,ovrflow); 

wire [31:0] and_result, or_result;
genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin : and_block
        and and_gate(and_result[i], data_operandA[i], data_operandB[i]);
    end
endgenerate

generate
    for (i = 0; i < 32; i = i + 1) begin : or_block
        or or_gate(or_result[i], data_operandA[i], data_operandB[i]);
    end
endgenerate

wire [31:0]addresult;
wire [31:0]subresult;
wire suboverflow;
wire addoverflow;
csa suba(data_operandA,data_operandB,5'b00001,subresult,suboverflow);
csa adda(data_operandA,data_operandB,5'b00000,addresult,addoverflow);

wire [31:0]calresult;
assign calresult = ctrl_ALUopcode[0] ? subresult : addresult;
assign overflow = ctrl_ALUopcode[0] ? suboverflow : addoverflow;

wire [31:0]opresult;
assign opresult = ctrl_ALUopcode[0] ? or_result : and_result;


wire [31:0]sllresult;
sll slla(data_operandA,ctrl_shiftamt,sllresult);
wire [31:0]sraresult;
sra sraa(data_operandA,ctrl_shiftamt,sraresult);
wire [31:0]shiftresult;
assign shiftresult = ctrl_ALUopcode[0] ? sraresult : sllresult;

wire [31:0]calorop;
assign calorop = ctrl_ALUopcode[1] ? opresult : calresult;

assign data_result = ctrl_ALUopcode[2] ? shiftresult : calorop;


endmodule


module csa(data_operandA,data_operandB,ctrl_ALUopcode,sum_result,overflow);
	input[31:0] data_operandA;
	input[31:0] data_operandB;
	input[5:0] ctrl_ALUopcode;
	output[31:0] sum_result;
	output overflow;

wire [31:0] neg_B;
genvar i;
generate
	for (i=0;i<32;i=i+1) begin : not_block
		not not_gate(neg_B[i],data_operandB[i]);
	end
endgenerate
	
wire [31:0]data_operandB_out;

assign data_operandB_out = ctrl_ALUopcode[0] ? neg_B : data_operandB;


wire[15:0] sum_upper_carry0,sum_upper_carry1;
wire carry_out_lower,carry_out_upper0,carry_out_upper1;
full_adder fa_lower(
	data_operandA[15:0],
	data_operandB_out[15:0],
	ctrl_ALUopcode[0],
	carry_out_lower,
	sum_result[15:0]);

full_adder fa_upper_carry0(
	data_operandA[31:16],
	data_operandB_out[31:16],
	1'b0,
	carry_out_upper0,
	sum_upper_carry0);

full_adder fa_upper_carry1(
	data_operandA[31:16],
	data_operandB_out[31:16],
	1'b1,
	carry_out_upper1,
	sum_upper_carry1);
	
assign sum_result[31:16] = carry_out_lower ? sum_upper_carry1 : sum_upper_carry0;

wire overflow_add;
wire overflow_sub;
//case 1 subtract:
wire tempsub0;
wire tempsub1;
xor(tempsub0,data_operandA[31],data_operandB[31]);
xor(tempsub1,data_operandA[31],sum_result[31]);
and(overflow_sub,tempsub0,tempsub1);
//case 2 add
wire tempadd0;
wire tempadd1;
xnor(tempadd0,data_operandA[31],data_operandB[31]);
xor(tempadd1,data_operandA[31],sum_result[31]);
and(overflow_add,tempadd0,tempadd1);

assign overflow = ctrl_ALUopcode[0] ? overflow_sub : overflow_add;

endmodule


module sll(data_in, shift_amt, data_out);
    input [31:0] data_in;
    input [4:0] shift_amt;
    output [31:0] data_out;

    wire [31:0] stage1, stage2, stage3,stage4;

    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : shift_by_1
            assign stage1[i + 1] = shift_amt[0] ? data_in[i] : data_in[i + 1];
        end
        assign stage1[0] = shift_amt[0] ? 1'b0 : data_in[0];
    endgenerate

    generate
        for (i = 0; i < 30; i = i + 1) begin : shift_by_2
            assign stage2[i + 2] = shift_amt[1] ? stage1[i] : stage1[i + 2];
        end
        assign stage2[1:0] = shift_amt[1] ? 2'b00 : stage1[1:0];
    endgenerate

    generate
        for (i = 0; i < 28; i = i + 1) begin : shift_by_4
            assign stage3[i + 4] = shift_amt[2] ? stage2[i] : stage2[i + 4];
        end
        assign stage3[3:0] = shift_amt[2] ? 4'b0000 : stage2[3:0];
    endgenerate

    generate
        for (i = 0; i < 24; i = i + 1) begin : shift_by_8
            assign stage4[i + 8] = shift_amt[3] ? stage3[i] : stage3[i + 8];
        end
        assign stage4[7:0] = shift_amt[3] ? 8'b00000000 : stage3[7:0];
    endgenerate

    generate
        for (i = 0; i < 16; i = i + 1) begin : shift_by_16
            assign data_out[i + 16] = shift_amt[4] ? stage4[i] : stage4[i + 16];
        end
        assign data_out[15:0] = shift_amt[4] ? 16'b0000000000000000 : stage4[15:0];
    endgenerate

endmodule

module sra(data_in, shift_amt, data_out);
    input [31:0] data_in;
    input [4:0] shift_amt;
    output [31:0] data_out;

    wire [31:0] stage1, stage2, stage3, stage4;
	 wire [1:0]header2;
	 wire [3:0]header4;
	 wire [7:0]header8;
	 wire [15:0]header16;
	 assign header2 = data_in[31] ? 2'b11 : 2'b00;
	 assign header4 = data_in[31] ? 4'b1111 : 4'b0000;
	 assign header8 = data_in[31] ? 8'b11111111 : 8'b00000000;
	 assign header16 = data_in[31] ? 16'b1111111111111111 : 16'b0000000000000000;
    genvar i;
    generate
        for (i = 1; i < 32; i = i + 1) begin : shift_by_1
            assign stage1[i - 1] = shift_amt[0] ? data_in[i] : data_in[i - 1];
        end
        assign stage1[31] = shift_amt[0] ? data_in[31] : data_in[31];
    endgenerate

    generate
        for (i = 2; i < 32; i = i + 1) begin : shift_by_2
            assign stage2[i - 2] = shift_amt[1] ? stage1[i] : stage1[i - 2];
        end
        assign stage2[31:30] = shift_amt[1] ? header2 : stage1[31:30];
    endgenerate

    generate
        for (i = 4; i < 32; i = i + 1) begin : shift_by_4
            assign stage3[i - 4] = shift_amt[2] ? stage2[i] : stage2[i - 4];
        end
        assign stage3[31:28] = shift_amt[2] ? header4 : stage2[31:28];
    endgenerate

    generate
        for (i = 8; i < 32; i = i + 1) begin : shift_by_8
            assign stage4[i - 8] = shift_amt[3] ? stage3[i] : stage3[i - 8];
        end
        assign stage4[31:24] = shift_amt[3] ? header8 : stage3[31:24];
    endgenerate

    generate
        for (i = 16; i < 32; i = i + 1) begin : shift_by_16
            assign data_out[i - 16] = shift_amt[4] ? stage4[i] : stage4[i - 16];
        end
        assign data_out[31:16] = shift_amt[4] ? header16 : stage4[31:16];
    endgenerate

endmodule


module fa(a, b, cin, cout, sum);
    input a;
    input b;
    input cin;
    output sum;
    output cout;
    
    wire and0;
    wire and1;
    wire and2;
    
    xor(sum, a, b, cin);
    and(and0, a, b);
    and(and1, b, cin);
    and(and2, a, cin);
    or(cout, and0, and1, and2);
endmodule


module full_adder(numA, numB, cin, cout, sum);
    input [15:0] numA;
    input [15:0] numB;
    input cin;
    output cout;
    output [15:0] sum;
    wire c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15;

    fa fa0(numA[0], numB[0], cin, c0, sum[0]);
    fa fa1(numA[1], numB[1], c0, c1, sum[1]);
    fa fa2(numA[2], numB[2], c1, c2, sum[2]);
    fa fa3(numA[3], numB[3], c2, c3, sum[3]);
    fa fa4(numA[4], numB[4], c3, c4, sum[4]);
    fa fa5(numA[5], numB[5], c4, c5, sum[5]);
    fa fa6(numA[6], numB[6], c5, c6, sum[6]);
    fa fa7(numA[7], numB[7], c6, c7, sum[7]);
    fa fa8(numA[8], numB[8], c7, c8, sum[8]);
    fa fa9(numA[9], numB[9], c8, c9, sum[9]);
    fa fa10(numA[10], numB[10], c9, c10, sum[10]);
    fa fa11(numA[11], numB[11], c10, c11, sum[11]);
    fa fa12(numA[12], numB[12], c11, c12, sum[12]);
    fa fa13(numA[13], numB[13], c12, c13, sum[13]);
    fa fa14(numA[14], numB[14], c13, c14, sum[14]);
    fa fa15(numA[15], numB[15], c14, cout, sum[15]);

endmodule
