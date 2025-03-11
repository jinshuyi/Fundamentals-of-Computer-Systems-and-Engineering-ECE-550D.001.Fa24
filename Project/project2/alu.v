module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;

   // YOUR CODE HERE //
	
	// adder / suber
	wire [31:0] addr; 
	
	wire [31:0] subr; 
	
	wire ofa; 
	wire ofs; 
	wire id_less_than;
	wire id_non_zero;
	
	adding addO(data_operandA[31:0], data_operandB[31:0], addr[31:0], ofa); // add operation
	subtracting subO(data_operandA[31:0], data_operandB[31:0], subr[31:0], ofs, id_less_than, id_non_zero); // substract operation
	
	
	wire [31:0] andr;//and
	wire [31:0] orr;//or
	
	AND_Operation and0(data_operandA[31:0], data_operandB[31:0], andr);
	OR_Operation or0(data_operandA[31:0], data_operandB[31:0], orr);
	
	
	
	
	//right shift
	wire [31:0] SRA_Rightr;
	SRA_Right SRA_Right0(data_operandA[31:0], ctrl_shiftamt, SRA_Rightr);
	
	// left shift
	wire [31:0] SLL_Leftr;
	SLL_Left SLL_Left0(data_operandA[31:0], ctrl_shiftamt, SLL_Leftr);
	

	
	
	// selectors by using the mux
	assign data_result[31:0] = ctrl_ALUopcode[2] ? (ctrl_ALUopcode[0] ? SRA_Rightr : SLL_Leftr) : (ctrl_ALUopcode[1] ? (ctrl_ALUopcode[0] ? orr : andr) : (ctrl_ALUopcode[0] ? subr : addr)); //  checking the final
	assign overflow = ctrl_ALUopcode[4] ? 1'b0 : (ctrl_ALUopcode[3] ? 1'b0 : (ctrl_ALUopcode[2] ? 1'b0 : ((ctrl_ALUopcode[1] ? 1'b0 : (ctrl_ALUopcode[0] ? ofs : ofa))))); // dectect overflow
	assign isNotEqual = ctrl_ALUopcode[4] ? 1'b0 : (ctrl_ALUopcode[3] ? 1'b0 : (ctrl_ALUopcode[2] ? 1'b0 : ((ctrl_ALUopcode[1] ? 1'b0 : (ctrl_ALUopcode[0] ? id_non_zero : 1'b0))))); // mux for check the isNotEqual
	assign isLessThan = ctrl_ALUopcode[4] ? 1'b0 : (ctrl_ALUopcode[3] ? 1'b0 : (ctrl_ALUopcode[2] ? 1'b0 : ((ctrl_ALUopcode[1] ? 1'b0 : (ctrl_ALUopcode[0] ? id_less_than : 1'b0))))); // mux for check the isNotEqual
	

endmodule