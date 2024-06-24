`timescale 1ns/1ns
module fifo
#( parameter fifo_depth = 16,
   parameter fifo_bitwidth = 8)
   (clk,rst_n,w_en,data_w,r_en,data_r,full,empty,half_full,overflow);
// define fifo_depth and fifo_bitwidth as the parametre

input   clk;
input   rst_n;
input   w_en;
input   r_en;
input   [fifo_bitwidth - 1 : 0] data_w;

output   full;
output   empty;
output   half_full;
output   overflow;
output   [fifo_bitwidth - 1 : 0]   data_r;

localparam bits_fifo_depth = $clog2(fifo_depth);   //calculate the code length of fifo_depth

reg  [bits_fifo_depth : 0] wr_ptr;  //add an extra bit to (bits_fifo_depth - 1) to judge the empty and full
reg  [bits_fifo_depth : 0] rd_ptr;
reg        overflow;
reg   [fifo_bitwidth - 1 : 0]   data_r;
wire  [fifo_bitwidth - 1 : 0]   data_in;

reg [fifo_bitwidth - 1 : 0] fifo_mem [0 : fifo_depth - 1];  //define fifo_mem


//write function
always @(posedge clk)
if(w_en & ~full)
   fifo_mem[wr_ptr[bits_fifo_depth - 1 : 0]] <= data_w; //use [bits_fifo_depth - 1 : 0] as index
else
   fifo_mem[wr_ptr[bits_fifo_depth - 1 : 0]] <= fifo_mem[wr_ptr[bits_fifo_depth - 1 : 0]];
 
//read function 
always @(posedge clk or negedge rst_n)
if(!rst_n)
   data_r <= 'b0;
else if(r_en & ~empty)
   data_r <= fifo_mem[rd_ptr[bits_fifo_depth - 1 : 0]];
else
   data_r <= data_r;

//wr_ptr
always @(posedge clk or negedge rst_n)
if(!rst_n)
   wr_ptr <= 'b0;
else if(w_en & ~full)
   wr_ptr <= wr_ptr + 1'b1;
else
   wr_ptr <= wr_ptr;
   
//read_ptr
always @(posedge clk or negedge rst_n)
if(!rst_n)
   rd_ptr <= 'b0;
else if(r_en & ~empty)
   rd_ptr <= rd_ptr + 1'b1;
else
   rd_ptr <= rd_ptr;

assign  empty = (rd_ptr[bits_fifo_depth : 0] == wr_ptr[bits_fifo_depth : 0]);
assign  full = ((rd_ptr[bits_fifo_depth] == ~wr_ptr[bits_fifo_depth]) & (rd_ptr[bits_fifo_depth - 1 : 0] == wr_ptr[bits_fifo_depth - 1 : 0]));
assign  half_full = ((rd_ptr[bits_fifo_depth - 1] == ~wr_ptr[bits_fifo_depth - 1]) & (rd_ptr[bits_fifo_depth - 2 : 0] == wr_ptr[bits_fifo_depth - 2 : 0]));

//overflow
always @(posedge clk or negedge rst_n)
if(!rst_n)
   overflow <= 1'b0;
else
   overflow <= full & w_en;
   


endmodule 

