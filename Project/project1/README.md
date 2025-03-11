# Project 1

 - Shuyi Jin
 - sj445

## Overall  Text Description

For this project, my task is to design and simulate an Arithmetic Logic Unit (ALU) using Quartus and Verilog. Specifically, I need to implement an adder that handles both addition and subtraction for two 32-bit numbers, ensuring that it is not a Ripple Carry Adder (RCA) of them.

My design mainly consists of 5 parts : the main function of ALU just as given, the half adder module, the full adder module, the addition module, the subtraction module and the 16 bits RCA module.

To begin with,the half adder module is a half adder that takes two 1-bit inputs and produces the sum and carry-out as outputs. It is implemented using an AND gate and an XOR gate. On the other hand, the  full adder  module is a full adder that operates with two 1-bit inputs and a carry-in, generating the sum and carry-out as outputs. This module is designed using two XOR gates, two AND gates, and one OR gate.

For the addition part, 3 16 bits RCA are used by me. The carry-out from the first 16 bits is used to determine the next 16-bit result. One thing to mention is that the result obtained has several repetitive calculations, so a generator is added. After obtaining the sum, overflow detection is done by comparing the most significant bit of the sum.

In terms of the subtraction part, the core idea is A-B converts to A+(-B). To implement this, I first invert the bits of in2 to create using a 'generate for' loop and calculate with 16-bit RCA adders.  For the first 16 bits, I set the initial carry-in to 1'b1, and the carry-out from these bits is then used to determine the result for the next 16 bits. Once the final result is obtained, overflow is detected by comparing the leftmost bit of the sum. Then the overflow is derived by me. After completing these steps, the module outputs both the subtraction result and the overflow.

This is the whole procedure of my project 1.











