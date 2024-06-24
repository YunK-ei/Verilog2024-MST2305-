`include "global.v"

module data_rom(
	input					                clk,
	input					                rst_n,
	input	[9:0]			            aa,
	input					                cena,
	output   reg    [`WD-1:0]	qa
	);
  /*
	//32*32*8
    rom_32x32_8 rom(
        // A is write port
        .clka(clk),
        .ena(!cena),
        // .web(1'b0),
        .addra(aa),
        // .dinb(8'd0),
        .douta(qa) 
    );
    */
  reg [`WD-1:0] mem [0:1023];
  initial
  $readmemh("E:/ToDo/Verilog2024/Lab5/lenet_2/output.txt",mem);

   always @ (posedge clk)
   if(!cena)
       qa=mem[aa];

endmodule
