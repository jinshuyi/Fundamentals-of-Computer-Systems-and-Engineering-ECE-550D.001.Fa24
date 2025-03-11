/*This imem  utilizes the Altera altsyncram component, configured for 4096 words (each 32 bits wide) to store predefined instructions. 
The 12-bit address input allows access to up to 4096 memory locations, while the clock input synchronizes memory access. The 32-bit q output provides instruction data during read operations. 
The altsyncram component is set to operate in ROM mode (operation_mode = "ROM"), with data pre-initialized from a specified memory initialization file (basic_test.mif). This file is loaded upon power-up, making the memory read-only. Always-on byte and clock enables support continuous access, and synopsys translate_off and translate_on directives ensure simulation-specific timescale and tri1 declarations are ignored during synthesis.

*/
//translate_off
`timescale 1 ps / 1 ps
// translate_on
module imem (
	address,
	clock,
	q);

	input	[11:0]  address;
	input	  clock;
	output	[31:0]  q;
`ifndef ALTERA_RESERVED_QIS
// translate_off
`endif
	tri1	  clock;
`ifndef ALTERA_RESERVED_QIS
// translate_on
`endif

	wire [31:0] sub_wire0;
	wire [31:0] q = sub_wire0[31:0];

	altsyncram	altsyncram_component (
				.address_a (address),
				.clock0 (clock),
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
				.data_a ({32{1'b1}}),
				.data_b (1'b1),
				.eccstatus (),
				.q_b (),
				.rden_a (1'b1),
				.rden_b (1'b1),
				.wren_a (1'b0),
				.wren_b (1'b0));
	defparam
		altsyncram_component.address_aclr_a = "NONE",
		altsyncram_component.clock_enable_input_a = "BYPASS",
		altsyncram_component.clock_enable_output_a = "BYPASS",
		altsyncram_component.init_file = "../reference/out/mif_outputs/basic_test.mif",
		altsyncram_component.intended_device_family = "Cyclone IV E",
		altsyncram_component.lpm_hint = "ENABLE_RUNTIME_MOD=NO",
		altsyncram_component.lpm_type = "altsyncram",
		altsyncram_component.numwords_a = 4096,
		altsyncram_component.operation_mode = "ROM",
		altsyncram_component.outdata_aclr_a = "NONE",
		altsyncram_component.outdata_reg_a = "CLOCK0",
		altsyncram_component.widthad_a = 12,
		altsyncram_component.width_a = 32,
		altsyncram_component.width_byteena_a = 1;


endmodule
