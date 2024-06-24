`timescale  1ns / 1ns

module tb_clk_div;

// clk_div Parameters
parameter PERIOD  = 10;


// clk_div Inputs
reg   rst_n                                = 0 ;
reg   clk                           = 0 ;

// clk_div Outputs
wire  clk_100hz                            ;
wire  clk_25mhz                            ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
    #(PERIOD*10000);
    $finish;
end

clk_div  u_clk_div (
    .rst_n                   ( rst_n        ),
    .clk	              ( clk   ),

    .clk_100hz               ( clk_100hz    ),
    .clk_25mhz               ( clk_25mhz    )
);


endmodule