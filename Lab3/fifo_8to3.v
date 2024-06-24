`timescale 1ns/1ns
module fifo
   (clk,rst_n,w_en,data_w,r_en,data_r,full,empty,half_full,overflow);


input   clk;
input   rst_n;
input   w_en;
input   r_en;
input   [8 - 1 : 0] data_w;

output   full;
output   empty;
output   half_full;
output   overflow;
output   [8 - 1 : 0]   data_r;

//State Machine

localparam [2:0] STATE0 = 3'b000,
                  STATE1 = 3'b001,
                  STATE2 = 3'b010,
                  STATE3 = 3'b011,
                  STATE4 = 3'b100,
                  STATE5 = 3'b101,
                  STATE6 = 3'b110,
                  STATE7 = 3'b111;

reg [2:0] state, state_nxt;


reg  [4 : 0] wr_ptr;  //add an extra bit to (4 - 1) to judge the empty and full
reg  [4 : 0] rd_ptr;
reg  [4 : 0] rd_ptr_nxt;

wire [4 : 0] rd_ptr_minus1;
assign  rd_ptr_minus1 = rd_ptr[4 : 0] - 1'b1;

reg        overflow;

reg   [8 - 1 : 0]   data_r;
reg   [8 - 1 : 0]   data_r_nxt;

wire  [8 - 1 : 0]   data_in;

reg [8 - 1 : 0] fifo_mem [0 : 16 - 1];  //define fifo_mem

//write function
always @(posedge clk)
if(w_en & ~full)
   fifo_mem[wr_ptr[4 - 1 : 0]] <= data_w; //use [4 - 1 : 0] as index
else
   fifo_mem[wr_ptr[4 - 1 : 0]] <= fifo_mem[wr_ptr[4 - 1 : 0]];
 
//read function 
// always @(posedge clk or negedge rst_n)
// if(!rst_n)
//    data_r <= 'b0;
// else if(r_en & ~empty)
//    data_r <= fifo_mem[rd_ptr[4 - 1 : 0]];
// else
//    data_r <= data_r;

//change the behavior of read_ptr according to the state machine

always @(posedge clk or negedge rst_n)
begin
   if(!rst_n) begin
      rd_ptr <= 5'b00000;
   end
   else
      rd_ptr <= rd_ptr_nxt;
end

//wr_ptr
always @(posedge clk or negedge rst_n)
if(!rst_n)
   wr_ptr <= 'b0;
else if(w_en & ~full)
   wr_ptr <= wr_ptr + 1'b1;
else
   wr_ptr <= wr_ptr;
   
//read_ptr
// always @(posedge clk or negedge rst_n)
// if(!rst_n)
//    rd_ptr <= 'b0;
// else if(r_en & ~empty)
//    rd_ptr <= rd_ptr + 1'b1;
// else
//    rd_ptr <= rd_ptr;

//change the behavior of read_ptr according to the state machine
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n) begin
      data_r <= 3'b000;
   end
   else
      data_r <= data_r_nxt;
end


always @(*)
begin
   case(state)
   STATE0:
      if(r_en & !empty)
      begin
         state_nxt = STATE1;
         data_r_nxt = fifo_mem[rd_ptr[3:0]][2:0];
         rd_ptr_nxt = rd_ptr;
      end
      else
      begin
         state_nxt = STATE0;
         data_r_nxt = data_r;
         rd_ptr_nxt = rd_ptr;
      end
   STATE1:
      if(r_en & !empty)
      begin
         state_nxt = STATE2;
         data_r_nxt = fifo_mem[rd_ptr[3:0]][5:3];
         rd_ptr_nxt = rd_ptr + 1'b1;
      end
      else
      begin
         state_nxt = STATE1;
         data_r_nxt = data_r;
         rd_ptr_nxt = rd_ptr;
      end
   STATE2:
      if(r_en & !empty)
      begin
         state_nxt = STATE3;
         data_r_nxt = {fifo_mem[rd_ptr[3:0]][0] ,fifo_mem[rd_ptr_minus1[3:0]][7:6]};
         rd_ptr_nxt = rd_ptr;
      end
      else
      begin
         state_nxt = STATE2;
         data_r_nxt = data_r;
         rd_ptr_nxt = rd_ptr;
      end
   STATE3:
      if(r_en & !empty)
      begin
         state_nxt = STATE4;
         data_r_nxt = fifo_mem[rd_ptr[3:0]][3:1];
         rd_ptr_nxt = rd_ptr;
      end
      else
      begin
         state_nxt = STATE3;
         data_r_nxt = data_r;
         rd_ptr_nxt = rd_ptr;
      end
   STATE4:
      if(r_en & !empty)
      begin
         state_nxt = STATE5;
         data_r_nxt = fifo_mem[rd_ptr[3:0]][6:4];
         rd_ptr_nxt = rd_ptr + 1'b1;
      end
      else
      begin
         state_nxt = STATE4;
         data_r_nxt = data_r;
         rd_ptr_nxt = rd_ptr;
      end
   STATE5:
      if(r_en & !empty)
      begin
         state_nxt = STATE6;
         data_r_nxt = {fifo_mem[rd_ptr[3:0]][1:0], fifo_mem[rd_ptr_minus1[3:0]][7]};
         rd_ptr_nxt = rd_ptr;
      end
      else
      begin
         state_nxt = STATE5;
         data_r_nxt = data_r;
         rd_ptr_nxt = rd_ptr;
      end
   STATE6:
      if(r_en & !empty)
      begin
         state_nxt = STATE7;
         data_r_nxt = fifo_mem[rd_ptr[3:0]][4:2];
         rd_ptr_nxt = rd_ptr;
      end
      else
      begin
         state_nxt = STATE6;
         data_r_nxt = data_r;
         rd_ptr_nxt = rd_ptr;
      end
   STATE7:
      if(r_en & !empty)
      begin
         state_nxt = STATE0;
         data_r_nxt = fifo_mem[rd_ptr[3:0]][7:5];
         rd_ptr_nxt = rd_ptr + 1'b1;
      end
      else
      begin
         state_nxt = STATE7;
         data_r_nxt = data_r;
         rd_ptr_nxt = rd_ptr;
      end
   default:state_nxt = 3'b000;
   endcase
end

always @(posedge clk or negedge rst_n)
begin
   if(!rst_n) begin
      state <= 3'b000;
   end
   else
      state <= state_nxt;
end



assign  empty = (rd_ptr[4 : 0] == wr_ptr[4 : 0]);
assign  full = ((rd_ptr[4] == ~wr_ptr[4]) && (rd_ptr[4 - 1 : 0] == wr_ptr[4 - 1 : 0]));
assign  half_full = ((rd_ptr[4 - 1] == ~wr_ptr[4 - 1]) && (rd_ptr[4 - 2 : 0] == wr_ptr[4 - 2 : 0]));

//overflow
always @(posedge clk or negedge rst_n)
if(!rst_n)
   overflow <= 1'b0;
else
   overflow <= full & w_en;
   


endmodule 