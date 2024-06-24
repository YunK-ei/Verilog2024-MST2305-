module clk_div(rst_n, clk, clk_100hz, clk_25mhz);
    input rst_n;
    input clk;
    output reg clk_100hz;
    output reg clk_25mhz;

    localparam NumBits_1m = $clog2(1000000);
    localparam NumBits_4 = $clog2(4);
    reg [NumBits_4 - 1 : 0] cnt_4;
    reg [NumBits_1m - 1 : 0] cnt_1m;

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt_4 <= 'b0;
        else if(cnt_4 == 2'd1)
            cnt_4 <= 'b0;
        else
            cnt_4 <= cnt_4 + 1'b1;
    end

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt_1m <= 'b0;
        else if(cnt_1m == 'd499999)
            cnt_1m <= 'b0;
        else
            cnt_1m <= cnt_1m + 1'b1;
    end

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            clk_25mhz <= 1'b0;
        else if(cnt_4 == 2'd1)
            clk_25mhz <= !clk_25mhz;
        else
            clk_25mhz <= clk_25mhz;
    end

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            clk_100hz <= 1'b0;
        else if(cnt_1m == 'd499999)
            clk_100hz <= !clk_100hz;
        else
            clk_100hz <= clk_100hz;
    end
    
endmodule