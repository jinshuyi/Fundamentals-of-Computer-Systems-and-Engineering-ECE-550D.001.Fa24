module alu_instruction(
    input [31:0] data_operandA,   // First operand input (32 bits)
    input [31:0] data_operandB,   // Second operand input (32 bits)
    input [4:0] ctrl_ALUopcode,    // Control signal determining ALU operation
    input [4:0] ctrl_shiftamt,     // Shift amount for shift operations
    output [31:0] data_result,     // Output for the result of the ALU operation
    output isNotEqual,             // Flag indicating if operands are not equal
    output isLessThan,             // Flag indicating if operand A is less than operand B
    output overflow                // Flag indicating if overflow occurred
);

    wire signed [31:0] inner_A, inner_B; // Internal signed wires for operands
    reg signed [31:0] inner_result;       // Register to hold the result of the ALU operation
    reg inner_cout;                       // Register for carry out, used for overflow detection

    // Assign input operands to internal wires
    assign inner_A = data_operandA;
    assign inner_B = data_operandB;

    // Assign the result of the ALU operation to the output
    assign data_result = inner_result;

    // Determine if the two operands are not equal
    assign isNotEqual = inner_A != inner_B;

    // Determine if operand A is less than operand B
    assign isLessThan = inner_A < inner_B;

    // Check for overflow by comparing the carry out with the sign bit of the result
    assign overflow = inner_cout != inner_result[31];

    // ALU operation logic that responds to changes in control opcode or operands
    always @(ctrl_ALUopcode or inner_A or inner_B or ctrl_shiftamt) begin
        // Default to addition for the result and carry out
        {inner_cout, inner_result} = inner_A + inner_B;

        // Perform different operations based on the control opcode
        case (ctrl_ALUopcode)
            0 : {inner_cout, inner_result} = inner_A + inner_B;  // ADD operation
            1 : {inner_cout, inner_result} = inner_A - inner_B;  // SUBTRACT operation
            2 : inner_result = inner_A & inner_B;                  // AND operation
            3 : inner_result = inner_A | inner_B;                  // OR operation
            4 : inner_result = inner_A << ctrl_shiftamt;           // Shift left logical (SLL)
            5 : inner_result = inner_A >>> ctrl_shiftamt;          // Shift right arithmetic (SRA)
            // Additional operations can be added as needed
        endcase
    end

endmodule
