module counter#(
    parameter THRESHOLD = 6
)
(
    input wire clk,
    input reg  rst_n,
    output reg  out_en
);

    localparam LOG_THRESHOLD = $clog2(THRESHOLD);

    reg [LOG_THRESHOLD - 1 : 0] counter;

    always @(posedge clk or negedge rst_n)
    begin
	if(~rst_n)
	counter = 1'b0;
	else
        if(counter < THRESHOLD)
            counter = counter + 1;
        else
            counter = 1'b0; // Reset value when threshold reached
    end

    always@(*)
    if(counter == THRESHOLD)
        out_en = 1'b1;
    else
	out_en = 1'b0;
	
endmodule
