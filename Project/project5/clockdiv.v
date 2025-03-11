/*The provided Verilog code implements two clock divider modules: clk_div_2 and clk_div_4. 
The clk_div_2 module divides the input clock signal clk by 2, producing an output signal out_clk that toggles on each rising edge of clk, with a reset functionality to set out_clk to 0 when activated. 
The clk_div_4 module divides the input clock signal by 4, using a 2-bit register to count clock cycles and toggling its output clk_out when the count reaches 2. 
Both modules include reset functionality to initialize their outputs.

*/


// clock divide by 2
module clk_div_2 (clk, reset, out_clk);
    output reg out_clk;  // Output clock signal (divided by 2)
    input clk;           // Input clock signal
    input reset;         // Reset signal

    always @(posedge clk) begin
        if (reset)       // Set output to 0 on reset
            out_clk <= 1'b0;
        else             // Toggle output on rising edge
            out_clk <= ~out_clk;	
    end
endmodule


// clock divide by 4
module clk_div_4 (clk, reset, clk_out);
    input clk;           // Input clock signal
    input reset;         // Reset signal
    output clk_out;      // Output clock signal (divided by 4)

    reg [1:0] r_reg;     // 2-bit counter
    wire [1:0] r_nxt;    // Next counter state
    reg clk_track;       // Toggled output clock

    always @(posedge clk or posedge reset) begin
        if (reset) begin  // Initialize on reset
            r_reg <= 2'b0;
            clk_track <= 1'b0;
        end
        else if (r_nxt == 2'b10) begin // Toggle output at count 2
            r_reg <= 0;              
            clk_track <= ~clk_track;  
        end
        else 
            r_reg <= r_nxt;            // Update counter
    end

    assign r_nxt = r_reg + 1;           // Next counter value
    assign clk_out = clk_track;          // Assign output
endmodule
