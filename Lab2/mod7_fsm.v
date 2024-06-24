module mod7_fsm (
    clk,
    rst_n,
    data_in,
    data_out,
    tmp
);
    input clk;
    input rst_n;
    input data_in;
    output [2:0] data_out;
    output reg [15:0] tmp;

    reg [2:0] state, state_nxt;

    localparam [2:0] STATE0 = 3'b000,
                    STATE1 = 3'b001,
                    STATE2 = 3'b010,
                    STATE3 = 3'b011,
                    STATE4 = 3'b100,
                    STATE5 = 3'b101,
                    STATE6 = 3'b110,
                    STATE7 = 3'b111;
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            begin
                state <= STATE0;
                tmp <= 16'b0000000000000000;
            end
        else
        begin
            state <= state_nxt;
            tmp[15:0] <= {tmp[14:0], data_in};
        end
    end

always @(*)    //State transmission
begin
if (tmp[15] == 0)
    begin
        case(state)
        STATE0:if (data_in) state_nxt = STATE1;
               else state_nxt = STATE0;
        STATE1:if (data_in) state_nxt = STATE3;
               else state_nxt = STATE2;
        STATE2:if (data_in) state_nxt = STATE5;
               else state_nxt = STATE4;
        STATE3:if (data_in) state_nxt = STATE0;
               else state_nxt = STATE6;
        STATE4:if (data_in) state_nxt = STATE2;
               else state_nxt = STATE1;
        STATE5:if (data_in) state_nxt = STATE4;
               else state_nxt = STATE3;
        STATE6:if (data_in) state_nxt = STATE6;
               else state_nxt = STATE5;
        default:state_nxt = 3'b000;
        endcase
    end
else
    begin
        case(state)
        STATE0:if (data_in) state_nxt = STATE6;
               else state_nxt = STATE5;
        STATE1:if (data_in) state_nxt = STATE1;
               else state_nxt = STATE0;
        STATE2:if (data_in) state_nxt = STATE3;
               else state_nxt = STATE2;
        STATE3:if (data_in) state_nxt = STATE5;
               else state_nxt = STATE4;
        STATE4:if (data_in) state_nxt = STATE0;
               else state_nxt = STATE6;
        STATE5:if (data_in) state_nxt = STATE2;
               else state_nxt = STATE1;
        STATE6:if (data_in) state_nxt = STATE4;
               else state_nxt = STATE3;
        default:state_nxt = 3'b000;
        endcase
    end
end

assign data_out = state;
    
endmodule