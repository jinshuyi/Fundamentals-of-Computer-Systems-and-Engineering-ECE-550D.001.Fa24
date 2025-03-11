module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;

   /* YOUR CODE HERE */
	
    // Internal wire declarations
    wire [31:0] decoded;      // Decoded signal to select write register
    wire [31:0] q[0:31];      // Array of 32 registers

    // Decode write register index
    bitChecker bit_result0(ctrl_writeReg, ctrl_writeEnable, decoded);

    // Register 0 is always 0
    dffe_ref dffe0(q[0], 32'b0, clock, decoded[0], ctrl_reset);

    // Generate D flip-flops for registers 1 to 31
    genvar i;
    generate 
        for(i = 1; i <= 31; i = i + 1) begin : regWriteCheck_loop
            dffe_ref dffei(q[i], data_writeReg, clock, decoded[i], ctrl_reset);
        end
    endgenerate

    // Read register A and B
    wire [31:0] decodeda, decodedb;
    bitChecker bca(ctrl_readRegA, 1'b1, decodeda);
    bitChecker bcb(ctrl_readRegB, 1'b1, decodedb);
	
	// read A & read B			
    generate 
        for(i = 0; i <= 31; i = i + 1) begin : readAB_loop
            // If the decoded signal for register A is high, assign its value to data_readRegA
            assign data_readRegA = decodeda[i] ? q[i] : 32'bz; // Use tri-state logic if not selected
            // If the decoded signal for register B is high, assign its value to data_readRegB
            assign data_readRegB = decodedb[i] ? q[i] : 32'bz; // Use tri-state logic if not selected
        end
    endgenerate

endmodule