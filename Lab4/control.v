module control(clk_100hz, rst_n, sw_en, pause, clear, time_sec_h, time_sec_l, time_msec_h, time_msec_l, time_out);
    input clk_100hz;
    input rst_n;
    input sw_en;
    input pause;
    input clear;
    output reg [2:0] time_sec_h;
    output reg [3:0] time_sec_l;
    output reg [3:0] time_msec_h;
    output reg [3:0] time_msec_l;
    output reg time_out;

    //maintain a realtime copy of time to implement pause function
    reg [2:0] time_sec_h_cp;
    reg [3:0] time_sec_l_cp;
    reg [3:0] time_msec_h_cp;
    reg [3:0] time_msec_l_cp;

    reg [2:0] time_sec_h_nxt;
    reg [3:0] time_sec_l_nxt;
    reg [3:0] time_msec_h_nxt;
    reg [3:0] time_msec_l_nxt;

    //refresh time_msec_l...
    always@(posedge clk_100hz or negedge rst_n) begin
        if(!rst_n)
            time_msec_l <= 4'b0;
        else if(!pause)
            time_msec_l <= time_msec_l_nxt;
    end

    always@(posedge clk_100hz or negedge rst_n) begin
        if(!rst_n)
            time_msec_h <= 4'b0;
        else if(!pause)
            time_msec_h <= time_msec_h_nxt;
    end

    always@(posedge clk_100hz or negedge rst_n) begin
        if(!rst_n)
            time_sec_l <= 4'b0;
        else if(!pause)
            time_sec_l <= time_sec_l_nxt;
    end

    always@(posedge clk_100hz or negedge rst_n) begin
        if(!rst_n)
            time_sec_h <= 4'b0;
        else if(!pause)
            time_sec_h <= time_sec_h_nxt;
    end

    //refresh regs for realtime copy
    always@(posedge clk_100hz or negedge rst_n) begin
        if(!rst_n)
            time_msec_l_cp <= 4'b0;
        else
            time_msec_l_cp <= time_msec_l_nxt;
    end

    always@(posedge clk_100hz or negedge rst_n) begin
        if(!rst_n)
            time_msec_h_cp <= 4'b0;
        else
            time_msec_h_cp <= time_msec_h_nxt;
    end

    always@(posedge clk_100hz or negedge rst_n) begin
        if(!rst_n)
            time_sec_l_cp <= 4'b0;
        else
            time_sec_l_cp <= time_sec_l_nxt;
    end

    always@(posedge clk_100hz or negedge rst_n) begin
        if(!rst_n)
            time_sec_h_cp <= 4'b0;
        else
            time_sec_h_cp <= time_sec_h_nxt;
    end

    assign fresh_msec_l = (time_msec_l_cp == 4'd9)? 1:0;
    always@(*) begin
        if(sw_en) begin
            if(fresh_msec_l | clear)
                time_msec_l_nxt = 4'b0;
            else
                time_msec_l_nxt = time_msec_l_cp + 1'b1;
        end
        else
            time_msec_l_nxt = time_msec_l_cp;
    end

    assign fresh_msec_h = (time_msec_h_cp == 4'd9 & fresh_msec_l)? 1:0;
    always@(*) begin
        if(sw_en) begin
            if(fresh_msec_h | clear)
                time_msec_h_nxt = 4'b0;
            else if(fresh_msec_l)
                time_msec_h_nxt = time_msec_h_cp + 1'b1;
            else
                time_msec_h_nxt = time_msec_h_cp;
        end
        else
            time_msec_h_nxt = time_msec_h_cp;
    end

    assign fresh_sec_l = (time_sec_l_cp == 4'd9 & fresh_msec_h)? 1:0;
    always@(*) begin
        if(sw_en) begin
            if(fresh_sec_l | clear)
                time_sec_l_nxt = 4'b0;
            else if(fresh_msec_h)
                time_sec_l_nxt = time_sec_l_cp + 1'b1;
            else
                time_sec_l_nxt = time_sec_l_cp;
        end
        else
            time_sec_l_nxt = time_sec_l_cp;
    end
    
    assign fresh_sec_h = (time_sec_h_cp == 3'd5 & fresh_sec_l)? 1:0;
    always@(*) begin
        if(sw_en) begin
            if(fresh_sec_h | clear)
                time_sec_h_nxt = 4'b0;
            else if(fresh_sec_l)
                time_sec_h_nxt = time_sec_h_cp + 1'b1;
            else
                time_sec_h_nxt = time_sec_h_cp;
        end
        else
            time_sec_h_nxt = time_sec_h_cp;
    end

    assign toggle = (fresh_sec_h | ((time_msec_l_nxt == 4'b0) & (time_msec_h_nxt == 4'b0) & (time_sec_l_nxt == 4'b0) & (time_sec_h_nxt == 3'd3)))? 1:0;
    always@(posedge clk_100hz or negedge rst_n) begin
        if(!rst_n)
            time_out = 1'b0;
        else if(clear)
            time_out = 1'b0;
        else if(toggle)
            time_out <= ~time_out;
        else
            time_out <= time_out;
    end
endmodule