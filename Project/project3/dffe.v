module dffe_ref(q, d, clk, en, clr);
   
   // Inputs
   input [31:0] d;      // 32-bit data input
   input clk, en, clr; // Clock, enable, and clear signals

   // Internal wire
   wire clr;  // Clear signal to reset the output register

   // Output
   output [31:0] q;  // 32-bit output register

   // Register to store the output value
   reg [31:0] q;

   // Initialize q to 0 at the start
   initial begin
       q = 32'b0;  // Set initial value of q to all zeros
   end

   // Update q on the rising edge of the clock or when the clear signal is high
   always @(posedge clk or posedge clr) begin
       // If clear is high, reset q to 0
       if (clr) begin
           q <= 32'b0;
       // If enable is high, load the value of d into q
       end else if (en) begin
           q <= d;
       end
   end

endmodule