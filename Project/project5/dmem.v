/*This Verilog module defines a single-port data memory (dmem) designed for read and write operations on Cyclone IV E FPGAs.
 It uses the Altera-specific altsyncram component configured for 4096 words (each 32 bits wide) and supports single-port access with either read or write per clock cycle. 
 The address input (12 bits) allows addressing up to 4096 memory locations, while the data input (32 bits) provides data for write operations, controlled by the wren signal. The q output (32 bits) returns data on reads, with an output register synchronized to clock. 
 The altsyncram component is configured to output new data immediately during a write (NEW_DATA_NO_NBE_READ) and uses always-on byte and clock enables for continuous operation. synopsys translate_off and translate_on directives prevent synthesis tools from interpreting simulation-specific timescale and tri1 declarations.
*/
`timescale 1 ps / 1 ps

module dmem (
	address,
	clock,
	data,
	wren,
	q);

	input	[11:0]  address;
	input	  clock;
	input	[31:0]  data;
	input	  wren;
	output	[31:0]  q;
`ifndef ALTERA_RESERVED_QIS

`endif
	tri1	  clock;
`ifndef ALTERA_RESERVED_QIS

`endif

	wire [31:0] sub_wire0;
	wire [31:0] q = sub_wire0[31:0];

	altsyncram	altsyncram_component (
				.address_a (address),
				.clock0 (clock),
				.data_a (data),
				.wren_a (wren),
				.q_a (sub_wire0),
				.aclr0 (1'b0),
				.aclr1 (1'b0),
				.address_b (1'b1),
				.addressstall_a (1'b0),
				.addressstall_b (1'b0),
				.byteena_a (1'b1),
				.byteena_b (1'b1),
				.clock1 (1'b1),
				.clocken0 (1'b1),
				.clocken1 (1'b1),
				.clocken2 (1'b1),
				.clocken3 (1'b1),
				.data_b (1'b1),
				.eccstatus (),
				.q_b (),
				.rden_a (1'b1),
				.rden_b (1'b1),
				.wren_b (1'b0));
	defparam
		altsyncram_component.clock_enable_input_a = "BYPASS",
		altsyncram_component.clock_enable_output_a = "BYPASS",
		altsyncram_component.intended_device_family = "Cyclone IV E",
		altsyncram_component.lpm_hint = "ENABLE_RUNTIME_MOD=NO",
		altsyncram_component.lpm_type = "altsyncram",
		altsyncram_component.numwords_a = 4096,
		altsyncram_component.operation_mode = "SINGLE_PORT",
		altsyncram_component.outdata_aclr_a = "NONE",
		altsyncram_component.outdata_reg_a = "CLOCK0",
		altsyncram_component.power_up_uninitialized = "FALSE",
		altsyncram_component.read_during_write_mode_port_a = "NEW_DATA_NO_NBE_READ",
		altsyncram_component.widthad_a = 12,
		altsyncram_component.width_a = 32,
		altsyncram_component.width_byteena_a = 1;


endmodule
