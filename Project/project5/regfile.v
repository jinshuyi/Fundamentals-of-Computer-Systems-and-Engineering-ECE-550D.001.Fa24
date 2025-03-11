
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
	
	wire [31:0]data_out[31:0];
	wire [31:0]write_out;
	writeport write_enable_out(ctrl_writeReg,ctrl_writeEnable,write_out);
   genvar i;
	generate
		for(i=1;i<32;i=i+1)begin: reg_block
			reg32 reg_init(
				.clk(clock),
				.en(write_out[i]),
				.clr(ctrl_reset),
				.d(data_writeReg),
				.q(data_out[i])
				);
		end
	endgenerate
	assign data_out[0] = 32'b0;
	
	wire [31:0]readA;
	decoder5to32 decodeA(ctrl_readRegA,readA);
	wire [31:0]readB;
	decoder5to32 decodeB(ctrl_readRegB,readB);

	generate
		for(i=0;i<32;i=i+1)begin:read_portA
			assign data_readRegA = readA[i] ? data_out[i] : 32'bz;
		end
	endgenerate
	
	 generate
      for (i = 0; i < 32; i = i + 1) begin: read_portB
         assign data_readRegB = (readB[i]) ? data_out[i] : 32'bz;
      end
   endgenerate
	
	
endmodule

module writeport(ctrl_writeReg,ctrl_writeEnable,write_enable_out);
	input ctrl_writeEnable;
	input [4:0] ctrl_writeReg;
	output [31:0] write_enable_out;
	
	wire [31:0] decode_out;
	
	decoder5to32 decode(ctrl_writeReg,decode_out);
	genvar i;
	generate 
		for(i=0;i<32;i=i+1)begin:write_port_out
			and(write_enable_out[i],ctrl_writeEnable,decode_out[i]);
		end
	endgenerate
endmodule

module reg32(
    input clk,         // Clock signal
    input en,          // Enable signal
    input clr,         // Clear signal
    input [31:0] d,    // 32-bit data input
    output [31:0] q    // 32-bit data output
);

   // Instantiate 32 D flip-flops
   genvar i;
   generate
       for (i = 0; i < 32; i = i + 1) begin : dff_block
           dffe_ref dff_inst(
               .q(q[i]), 
               .d(d[i]), 
               .clk(clk), 
               .en(en), 
               .clr(clr)
           );
       end
   endgenerate
endmodule


module decoder5to32(
    input [4:0] in,  // 5-bit input
    output [31:0] out // 32-bit output
);
    wire [4:0] not_in;  // NOT of input bits

    // Invert all input bits
    not (not_in[0], in[0]);
    not (not_in[1], in[1]);
    not (not_in[2], in[2]);
    not (not_in[3], in[3]);
    not (not_in[4], in[4]);

    // AND combinations for all possible outputs
    and (out[0],  not_in[4], not_in[3], not_in[2], not_in[1], not_in[0]);
    and (out[1],  not_in[4], not_in[3], not_in[2], not_in[1],  in[0]);
    and (out[2],  not_in[4], not_in[3], not_in[2],  in[1], not_in[0]);
    and (out[3],  not_in[4], not_in[3], not_in[2],  in[1],  in[0]);
    and (out[4],  not_in[4], not_in[3],  in[2], not_in[1], not_in[0]);
    and (out[5],  not_in[4], not_in[3],  in[2], not_in[1],  in[0]);
    and (out[6],  not_in[4], not_in[3],  in[2],  in[1], not_in[0]);
    and (out[7],  not_in[4], not_in[3],  in[2],  in[1],  in[0]);
    and (out[8],  not_in[4],  in[3], not_in[2], not_in[1], not_in[0]);
    and (out[9],  not_in[4],  in[3], not_in[2], not_in[1],  in[0]);
    and (out[10], not_in[4],  in[3], not_in[2],  in[1], not_in[0]);
    and (out[11], not_in[4],  in[3], not_in[2],  in[1],  in[0]);
    and (out[12], not_in[4],  in[3],  in[2], not_in[1], not_in[0]);
    and (out[13], not_in[4],  in[3],  in[2], not_in[1],  in[0]);
    and (out[14], not_in[4],  in[3],  in[2],  in[1], not_in[0]);
    and (out[15], not_in[4],  in[3],  in[2],  in[1],  in[0]);
    and (out[16],  in[4], not_in[3], not_in[2], not_in[1], not_in[0]);
    and (out[17],  in[4], not_in[3], not_in[2], not_in[1],  in[0]);
    and (out[18],  in[4], not_in[3], not_in[2],  in[1], not_in[0]);
    and (out[19],  in[4], not_in[3], not_in[2],  in[1],  in[0]);
    and (out[20],  in[4], not_in[3],  in[2], not_in[1], not_in[0]);
    and (out[21],  in[4], not_in[3],  in[2], not_in[1],  in[0]);
    and (out[22],  in[4], not_in[3],  in[2],  in[1], not_in[0]);
    and (out[23],  in[4], not_in[3],  in[2],  in[1],  in[0]);
    and (out[24],  in[4],  in[3], not_in[2], not_in[1], not_in[0]);
    and (out[25],  in[4],  in[3], not_in[2], not_in[1],  in[0]);
    and (out[26],  in[4],  in[3], not_in[2],  in[1], not_in[0]);
    and (out[27],  in[4],  in[3], not_in[2],  in[1],  in[0]);
    and (out[28],  in[4],  in[3],  in[2], not_in[1], not_in[0]);
    and (out[29],  in[4],  in[3],  in[2], not_in[1],  in[0]);
    and (out[30],  in[4],  in[3],  in[2],  in[1], not_in[0]);
    and (out[31],  in[4],  in[3],  in[2],  in[1],  in[0]);

endmodule
