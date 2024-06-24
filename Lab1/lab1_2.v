module lab1_2(
    clk, 
    rst_n, 
    not_q0,
    q1,
    q2
    );

    input clk;
    input rst_n;
    output not_q0, q1, q2;

    reg q2, q1, q0;
    wire q1_inp, q2_inp_or1, q2_inp_or2, q2_inp_or3, q2_inp;

    assign not_q0 = ~q0;
    assign q1_inp = q1 ^ q0;
    assign q2_inp_or1 = not_q0 & q2;
    assign q2_inp_or2 = q2 & (~q1);
    assign q2_inp_or3 = (~q2) & q1 & q0;
    assign q2_inp = q2_inp_or1 | q2_inp_or2 | q2_inp_or3;  
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            q2 <= 0;
            q1 <= 0;
            q0 <= 0;
        end

        else
        begin
            q2 <= q2_inp;
            q1 <= q1_inp; 
            q0 <= not_q0;
        end
    end
endmodule
