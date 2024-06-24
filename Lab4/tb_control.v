`timescale  1ns / 1ns

module tb_control;

// control Parameters
parameter PERIOD  = 10;


// control Inputs
reg   clk_100hz                            = 0 ;
reg   rst_n                                = 0 ;
reg   sw_en                                = 0 ;
reg   pause                                = 0 ;
reg   clear                                = 0 ;

// control Outputs
wire  [2:0]  time_sec_h                    ;
wire  [3:0]  time_sec_l                    ;
wire  [3:0]  time_msec_h                   ;
wire  [3:0]  time_msec_l                   ;
wire  time_out                             ;


initial
begin
    forever #(PERIOD/2)  clk_100hz=~clk_100hz;
end

initial
begin
    #(PERIOD*2) rst_n  =  1; sw_en = 1; 
    #(PERIOD*1000); sw_en = 1; pause = 1;
    #(PERIOD*1000); pause = 0;
    #(PERIOD*1000);
    #(PERIOD*6000);
    $finish;
end

control  u_control (
    .clk_100hz               ( clk_100hz          ),
    .rst_n                   ( rst_n              ),
    .sw_en                   ( sw_en              ),
    .pause                   ( pause              ),
    .clear                   ( clear              ),

    .time_sec_h              ( time_sec_h   [2:0] ),
    .time_sec_l              ( time_sec_l   [3:0] ),
    .time_msec_h             ( time_msec_h  [3:0] ),
    .time_msec_l             ( time_msec_l  [3:0] ),
    .time_out                ( time_out           )
);


endmodule