module bitChecker(
    input [4:0] control,   // 5-bit input control signal
    input enable,          // Enable signal (1-bit input)
    output [31:0] result   // 32-bit output result
);

    // First stage: Initialize with enable signal and 31 zeros
    wire [31:0] stage0;
    assign stage0 = {31'b0, enable};  // Concatenate 31 zeros with the enable bit

    // Intermediate wire declarations for each stage
    wire [31:0] stage1, stage2, stage3, stage4;

    // First shift stage: If control[0] is set, shift stage0 left by 1 bit
    assign stage1 = control[0] ? {stage0[30:0], 1'b0} : stage0;

    // Second shift stage: If control[1] is set, shift stage1 left by 2 bits
    assign stage2 = control[1] ? {stage1[29:0], 2'b0} : stage1;

    // Third shift stage: If control[2] is set, shift stage2 left by 4 bits
    assign stage3 = control[2] ? {stage2[27:0], 4'b0} : stage2;

    // Fourth shift stage: If control[3] is set, shift stage3 left by 8 bits
    assign stage4 = control[3] ? {stage3[23:0], 8'b0} : stage3;

    // Final stage: If control[4] is set, shift stage4 left by 16 bits and assign to result
    assign result = control[4] ? {stage4[15:0], 16'b0} : stage4;

endmodule