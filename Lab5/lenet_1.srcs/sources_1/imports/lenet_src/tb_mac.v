`timescale  1ns / 1ns

module tb_mac;

// mac Parameters
parameter PERIOD  = 10;


// mac Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   en                                   = 0 ;
reg   first_data                           = 0 ;
reg   last_data                            = 0 ;
reg   [8-1:0]  image_i                   = 0 ;
reg   [8-1:0]  weight_i                  = 0 ;

// mac Outputs
wire  q_en                                 ;
wire  [2*8:0]  q                         ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    // #(PERIOD*2) rst_n  =  1;
    // #(PERIOD) rst_n = 0;
    // #(PERIOD) rst_n = 1;
    // #(PERIOD/2) en = 1;
    // #(PERIOD) image_i = 2; weight_i = 2;
    // #(PERIOD) image_i = 1; weight_i = 3;
    // #(PERIOD) first_data = 1; image_i = 2; weight_i = 2;
    // #(PERIOD) first_data = 0; image_i = 3; weight_i = 4;
    // #(PERIOD) image_i = 5; weight_i = 1;
    // #(PERIOD) image_i = 2; weight_i = 4;
    // #(PERIOD) last_data = 1; image_i = 3; weight_i = 3;
    // #(PERIOD) last_data = 0; 
    // #(PERIOD) first_data = 1; image_i = 6; weight_i = 1;
    // #(PERIOD) first_data = 0; image_i = 3; weight_i = 3;
    // #(PERIOD) image_i = 2; weight_i = 7;
    // #(PERIOD) last_data = 1; image_i = 1; weight_i = 1;
    // #(PERIOD) last_data = 0;
    // #(PERIOD) en = 0;
    // #(3*PERIOD) $finish;
    //drive after always@(posedge clk)
end

mac  u_mac (
    .clk                     ( clk                   ),
    .rst_n                   ( rst_n                 ),
    .en                      ( en                    ),
    .first_data              ( first_data            ),
    .last_data               ( last_data             ),
    .image_i                 ( image_i     [8-1:0] ),
    .weight_i                ( weight_i    [8-1:0] ),

    .q_en                    ( q_en                  ),
    .q                       ( q           [2*8:0] )
);



endmodule