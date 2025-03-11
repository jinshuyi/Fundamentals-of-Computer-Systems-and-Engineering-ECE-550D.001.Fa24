# Project 2

 - Shuyi Jin
 - sj445
 - Full ALU project

## Overall  Text Description

For this project, my task is to design and simulate an Arithmetic Logic Unit (ALU) using Quartus and Verilog. Specifically, I need to implement an adder that handles both addition and subtraction for two 32-bit numbers, ensuring that it is not a Ripple Carry Adder (RCA) of them.

My design mainly consists of 5 parts : the main function of ALU just as given, the half adder module, the full adder module, the addition module, the subtraction module and the 16 bits RCA module.

To begin with,the half adder module is a half adder that takes two 1-bit inputs and produces the sum and carry-out as outputs. It is implemented using an AND gate and an XOR gate. On the other hand, the  full adder  module is a full adder that operates with two 1-bit inputs and a carry-in, generating the sum and carry-out as outputs. This module is designed using two XOR gates, two AND gates, and one OR gate.

For the addition part, 3 16 bits RCA are used by me. The carry-out from the first 16 bits is used to determine the next 16-bit result. One thing to mention is that the result obtained has several repetitive calculations, so a generator is added. After obtaining the sum, overflow detection is done by comparing the most significant bit of the sum.

In terms of the subtraction part, the core idea is A-B converts to A+(-B). To implement this, I first invert the bits of in2 to create using a 'generate for' loop and calculate with 16-bit RCA adders.  For the first 16 bits, I set the initial carry-in to 1'b1, and the carry-out from these bits is then used to determine the result for the next 16 bits. Once the final result is obtained, overflow is detected by comparing the leftmost bit of the sum. Then the overflow is derived by me. After completing these steps, the module outputs both the subtraction result and the overflow.

------------------------------------(The above is the same content of project 1)--------------------------------------------------------In this project , the check point asked us to add more functions of the alu we designed before, including AND_Operation, OR_Operation, SLL and SRA. I just add the module of this part in Verilog.

In the part of AND_Operation, this Verilog module implements a 32-bit bitwise AND operation. It takes two 32-bit input vectors, in1 and in2, and produces a 32-bit output vector, result, where each bit in result is the AND of the corresponding bits in in1 and in2. The module utilizes a generate loop to iterate through each bit from 0 to 31, applying the AND operation to each pair of bits.

In the section of OR_Operation,  the module implements a 32-bit bitwise OR operation. It takes two 32-bit input vectors, `in1` and `in2`, and produces a 32-bit output vector, `result`, where each bit in `result` is the OR of the corresponding bits in `in1` and `in2`. The module employs a generate loop to apply the OR operation to each bit from 0 to 31, ensuring a scalable and efficient design.

In SLL, it performs a logical left shift on a 32-bit input. It takes a 32-bit input vector `in` and a 5-bit shift amount `example`, producing a 32-bit output vector `out`. The module utilizes a series of conditional assignments to shift the input left by a number of bits specified by the `example` input, where each bit in `example` corresponds to a specific shift amount (1, 2, 4, 8, or 16 bits).

In SRA, this Verilog module performs an arithmetic right shift on a 32-bit input. It takes a 32-bit input vector `in` and a 5-bit shift amount `example`, producing a 32-bit output vector `out`. The module ensures that the sign bit (most significant bit) is propagated during the shift operation, maintaining the value's sign for negative numbers. Each bit in `example` corresponds to specific shift amounts (1, 2, 4, 8, or 16 bits), with conditional assignments handling the sign extension.

In total,  ALU module includes several key components for arithmetic and logical operations. The **AND_Operation** and **OR_Operation** modules perform bitwise AND and OR operations, respectively, on two 32-bit input operands, producing a 32-bit output. The **SLL (Shift Left Logical)** module shifts the input bits to the left by a specified number of positions, filling the least significant bits with zeros. In contrast, the **SRA (Shift Right Arithmetic)** module shifts the input bits to the right while preserving the sign bit (most significant bit) for negative numbers, ensuring that the output retains the original value's sign during the operation. Together, these components enable the ALU to perform a range of logical and shift operations effectively.

This is the whole conclude of project 2.











