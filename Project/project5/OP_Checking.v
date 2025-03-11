// This module checks the type of instruction based on the input 'q_imem' and generates various output signals 
// indicating whether the instruction is R-type, I-type, ALU operation, or memory operation. 
// It also determines if registers Rd, Rs, Rt are needed and checks for write register conditions.

module operchecker(input [31:0] q_imem,
						output isR,
						output isI,
						output isALU,
						output isAdd,
						output isAddi,
						output isSub,
						output isAnd,
						output isOr,
						output isSll,
						output isSra,
						output isSw,
						output isLw,
						output isDmem,
						output isNeedRd,
						output isNeedRs,
						output isNeedRt,
						output isWriteReg,
						output isJ,
						output isBne,
						output isJal,
						output isJr,
						output isBlt,
						output isBex,
						output isSetx,
						output isJI,
						output isB,
						output isBI);

	// check instruction type
	assign isR = (~q_imem[31])&(~q_imem[30])&(~q_imem[29])&(~q_imem[28])&(~q_imem[27]);
	assign isAddi = (~q_imem[31])&(~q_imem[30])&(q_imem[29])&(~q_imem[28])&(q_imem[27]);
	assign isSw = (~q_imem[31])&(~q_imem[30])&(q_imem[29])&(q_imem[28])&(q_imem[27]);
	assign isLw = (~q_imem[31])&(q_imem[30])&(~q_imem[29])&(~q_imem[28])&(~q_imem[27]);	
	
	// check JII type
	assign isJr = (~q_imem[31])&(~q_imem[30])&(q_imem[29])&(~q_imem[28])&(~q_imem[27]);//00100
	
	assign isI = isLw | isSw | isAddi | isJr;
	assign isDmem = isLw | isSw;
	
	// check Rd, Rs, Rt are needed
	assign isNeedRd = isR|isAddi|isSw|isLw;
	assign isNeedRs = isR|isAddi|isSw|isLw;
	assign isNeedRt = isR;
	
	// alu check
	assign isAdd = (~q_imem[6])&(~q_imem[5])&(~q_imem[4])&(~q_imem[3])&(~q_imem[2]);
	assign isSub = (~q_imem[6])&(~q_imem[5])&(~q_imem[4])&(~q_imem[3])&(q_imem[2]);
	assign isAnd = (~q_imem[6])&(~q_imem[5])&(~q_imem[4])&(q_imem[3])&(~q_imem[2]);
	assign isOr = (~q_imem[6])&(~q_imem[5])&(~q_imem[4])&(q_imem[3])&(q_imem[2]);
	assign isSll = (~q_imem[6])&(~q_imem[5])&(q_imem[4])&(~q_imem[3])&(~q_imem[2]);
	assign isSra = (~q_imem[6])&(~q_imem[5])&(q_imem[4])&(~q_imem[3])&(q_imem[2]);
	
	assign isALU = ((isR) & ((isAdd)|(isSub)|(isAnd)|(isOr)|(isSll)|(isSra))) | (isAddi);
	
	// check JI type
	assign isJ = (~q_imem[31])&(~q_imem[30])&(~q_imem[29])&(~q_imem[28])&(q_imem[27]);//00001
	assign isJal = (~q_imem[31])&(~q_imem[30])&(~q_imem[29])&(q_imem[28])&(q_imem[27]);//00011
	assign isBex = (q_imem[31])&(~q_imem[30])&(q_imem[29])&(q_imem[28])&(~q_imem[27]);//10110
	assign isSetx = (q_imem[31])&(~q_imem[30])&(q_imem[29])&(~q_imem[28])&(q_imem[27]);//10101
	
	// bne and blt
	assign isBne = (~q_imem[31])&(~q_imem[30])&(~q_imem[29])&(q_imem[28])&(~q_imem[27]);//00010
	assign isBlt = (~q_imem[31])&(~q_imem[30])&(q_imem[29])&(q_imem[28])&(~q_imem[27]);//00110
	
	
	assign isB = isBne | isBlt;
	assign isJI = isJ | isJal | isBex | isBne | isBlt | isJr;
	assign isBI = isB | isI;
	
	// Write Reg check
	assign isWriteReg = (isALU | isLw | isJal | isSetx) & (~isSw);
	 
endmodule