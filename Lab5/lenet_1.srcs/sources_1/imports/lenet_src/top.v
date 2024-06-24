`include "global.v"

module top(
    input clk,
    input rst_n,
    input start,
    output [3:0]num
);
	wire go;
	wire [3:0] digit;
	wire ready;
	wire [9:0] aa_image;
	wire [`WD-1:0] image_input;
	wire clk_out1;
	
  	reg start_r;
	assign num = digit;
  	assign go = start && !start_r;
  
	always@(posedge clk)
		if(!rst_n)
			start_r <= 'b0;
		else  
			start_r <= start;

  clk_wiz_0 instance_name
   (
    // Clock out ports
    .clk_out1(clk_out1),     // output clk_out1
    // Status and control signals
    .resetn(rst_n), // input resetn
   // Clock in ports
    .clk_in1(clk));      // input clk_in1
    
	data_rom data_rom_u(
		.clk			 (clk_out1),
		.rst_n		(rst_n),
		.aa				(aa_image),
		.cena			(cena_image),
		.qa				(image_input)
		);
		
	lenet lenet_u(
		.clk				      (clk_out1),
		.rst_n				    (rst_n),
		.go					    (go),				
		.cena_image			(cena_image),
		.aa_image			  (aa_image),
		.conv1_image		(image_input),
		.digit				    (digit),		
		.ready				    (ready)
		);

endmodule