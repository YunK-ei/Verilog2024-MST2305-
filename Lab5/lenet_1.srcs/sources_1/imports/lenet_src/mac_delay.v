`include "global.v"

module mac(
    input clk,
    input rst_n,
    input en,
    input first_data,
    input last_data,
    input [`WD-1:0] image_i,
    input [`WD-1:0] weight_i,
    output reg q_en,
    output reg [2*`WD:0] q
);


    reg [2*`WD:0] mul_reg;
    reg last_data_delay;
    reg working;

    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            working <= 1'b0;
        end
        else if(!en)
            working <= 1'b0;
        else if(first_data | last_data)
            working <= ~working;
        else
            working <= working;
    end
            

    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            last_data_delay <= 1'b0;
        end
        else
        begin
            last_data_delay <= last_data;
        end
    end

    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            mul_reg <= 'b0;
        end
        else if(!en)
            mul_reg <= 'b0;
        else if(working | first_data)
            mul_reg <= mul_reg + image_i * weight_i;
        else
            mul_reg <= 'b0;     
    end


    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            q <= 'b0;
        end
        else if(!en)
            q <= 'b0;
        else if(last_data_delay)
            q <= mul_reg;
        else
            q <= 'b0;
    end

    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            q_en <= 1'b0;
        else if(!en)
            q_en <= 1'b0;
        else if(last_data_delay)
            q_en <= 1'b1;
        else
            q_en <= 1'b0;
    end

    reg debug;
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            debug <= 1'b0;
        else if(mul_reg == 3'b100)
            debug <= 1'b1;
        else
            debug <= 1'b0;
    end
endmodule