`timescale  1ns / 1ps

module tb_lab1_2;

// lab1_2 Parameters
parameter PERIOD  = 10;


// lab1_2 Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 1 ;

// lab1_2 Outputs
wire  not_q0                               ;
wire  q1                                   ;
wire  q2                                   ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  0;
    #(PERIOD)   rst_n  =  1;
    #(PERIOD*20) rst_n =  0;
    #(PERIOD)   rst_n  =  1;
end

lab1_2  u_lab1_2 (
    .clk                     ( clk      ),
    .rst_n                   ( rst_n    ),

    .not_q0                  ( not_q0   ),
    .q1                      ( q1       ),
    .q2                      ( q2       )
);


endmodule