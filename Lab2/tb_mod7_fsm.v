`timescale  1ns / 1ps

module tb_mod7_fsm;

// mod7_fsm Parameters
parameter PERIOD  = 10;


// mod7_fsm Inputs
reg   clk                                  = 1 ;
reg   rst_n                                = 1 ;
reg   data_in                              = 0 ;

// mod7_fsm Outputs
wire  [2:0]  data_out                      ;
wire  [15:0]  tmp                          ;
wire   [2:0]  test_res                     ;

reg   [15:0] test_reg                      ;
reg   verify                               ;

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    verify = 0;
    rst_n = 0;
    #(PERIOD) rst_n = 1;
    #(PERIOD * 1000) $finish;
end

always @(negedge clk)	//test a random input 
	data_in <= ($random)%2;

always @(negedge clk)	//verify the output
	if (test_res != data_out) verify = 1;

always @(posedge clk or negedge rst_n)    //to test result
if (!rst_n) 
	test_reg = 16'b0000000000000000;
else 
        test_reg = {test_reg[14:0],data_in};

assign test_res = test_reg % 7;

mod7_fsm  u_mod7_fsm (
    .clk                     ( clk              ),
    .rst_n                   ( rst_n            ),
    .data_in                 ( data_in          ),

    .data_out                ( data_out  [2:0]  ),
    .tmp                     ( tmp       [15:0] )
);



endmodule