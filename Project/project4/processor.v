


/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile
);
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

	 
	 
	 //
    /* YOUR CODE STARTS HERE */
	 // pc
	 wire[31:0] npc;
	 wire[31:0] npcTemp;
	 assign npcTemp = npc;
	 wire[31:0] npcRes;
	 wire pcIsNotEqual, pcIsLessThan, pcOverflow;
	 // get next pc(current pc + 1)
	 alu_instruction getNPC(.data_operandA(npcTemp),
			.data_operandB(32'h1),
			.ctrl_ALUopcode(5'b0),
			.ctrl_shiftamt(5'b0),
			.data_result(npcRes),
			.isNotEqual(pcIsNotEqual),
			.isLessThan(pcIsLessThan),
			.overflow(pcOverflow));
	 // when finish all operation write next pc to pc reg and go to next instruction
	 dffe_imem pc_reg(npc, npcRes, clock, 1'b1, reset);
	 assign address_imem = npc[11:0];
	 
	 // check operation by imem
	 wire isR, isAddi, isSw,isLw, isI, isDmem;
	 wire isNeedRd, isNeedRs, isNeedRt;
	 wire isALU, isAdd, isSub, isAnd, isOr, isSll, isSra;
	 wire isWriteReg;
	 // get all operation checker from operchecker module
	 operchecker checker(.q_imem(q_imem),
						.isR(isR),
						.isI(isI),
						.isALU(isALU),
						.isAdd(isAdd),
						.isAddi(isAddi),
						.isSub(isSub),
						.isAnd(isAnd),
						.isOr(isOr),
						.isSll(isSll),
						.isSra(isSra),
						.isSw(isSw),
						.isLw(isLw),
						.isDmem(isDmem),
						.isNeedRd(isNeedRd),
						.isNeedRs(isNeedRs),
						.isNeedRt(isNeedRt),
						.isWriteReg(isWriteReg));
	 
	 wire [31:0] dataA, dataB;
	 wire [31:0] iNum; // Immediate number pass the SX to signed 32bits number
	 assign iNum = q_imem[16] ? {15'h7fff,q_imem[16:0]} : {15'b0,q_imem[16:0]};
	 // get dataA and dataB for do any operation
	 assign dataA = isI ? data_readRegB : data_readRegA;
	 assign dataB = isI ? iNum : data_readRegB;
	 
	 // alu
	 wire [31:0] dataRegALU;
	 wire aluIsNotEqual, aluIsLessThan, aluOverflow;
	 
	 wire [4:0] aulOper;
	 assign aulOper = isAddi ? 5'b0 : q_imem[6:2];
	 
	 // do alu operation
	 alu_instruction ALUOper(.data_operandA(dataA),
					.data_operandB(dataB),
					.ctrl_ALUopcode(aulOper),
					.ctrl_shiftamt(q_imem[11:7]),
					.data_result(dataRegALU),
					.isNotEqual(aluIsNotEqual),
					.isLessThan(aluIsLessThan),
					.overflow(aluOverflow));
	 
	 //check overflow for $rstatus
	 wire isAddOf, isAddiOf, isSubOf, isWRstatus;
	 assign isAddOf = isR & isALU & isAdd & aluOverflow;
	 assign isAddiOf = isI & isAddi & aluOverflow;
	 assign isSubOf = isR & isALU & isSub & aluOverflow;
	 assign isWRstatus = isAddOf | isAddiOf | isSubOf;
	 
	 // dmem address	 
	 wire[31:0] dmemAddr;
	 wire dmemIsNotEqual, dmemIsLessThan, dmemOverflow;
	 // get dmem address with the address in the reg and immediate number
	 alu_instruction getDmemAddr(.data_operandA(dataA),
			.data_operandB(dataB),
			.ctrl_ALUopcode(5'b0),
			.ctrl_shiftamt(5'b0),
			.data_result(dmemAddr),
			.isNotEqual(dmemIsNotEqual),
			.isLessThan(dmemIsLessThan),
			.overflow(dmemOverflow));
				 
	 
	 // Regfile output
	 // O: Write enable for regfile
	 assign ctrl_writeEnable = isWriteReg;
	 // O: Register to write to in regfile
	 assign ctrl_writeReg = isSw ? (5'b0) : (isWRstatus ? (5'd30) : (isNeedRd ? q_imem[26:22] : 5'b0));
	 // O: Register to read from port A of regfile
	 assign ctrl_readRegA = isI ? (q_imem[26:22]) : (isNeedRs ? q_imem[21:17] : 5'bz);
	 // O: Register to read from port B of regfile
	 assign ctrl_readRegB = isI ? (q_imem[21:17]) : (isNeedRt ? q_imem[16:12] : 5'bz);
	 // O: Data to write to for regfile (Alu result, Alu overflow rstatus, lw data)
	 assign data_writeReg = isWriteReg ? (isLw ? q_dmem : (isALU ? (isWRstatus ? (isAddOf ? 32'd1 : (isAddiOf ? 32'd2 : (isSubOf ? 32'd3 : 32'bz))) : dataRegALU) : 32'bz)) : 32'bz;
	 
	 // dmem output
	 // O: The address of the data to get or put from/to dmem
	 assign address_dmem = isDmem ? dmemAddr[11:0] : 12'bz;
	 // O: The data to write to dmem
	 assign data = isSw ? data_readRegA : 32'bz;
	 // O: Write enable for dmem
	 assign wren = isSw ? 1'b1 : 1'b0;
	 
endmodule