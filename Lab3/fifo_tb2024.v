`timescale 1ns/1ns
module testbench_fifo_final();

reg		clock,rst_n,r_en,w_en;
reg		[7:0]	in_data;
wire	[7:0]	out_data;
wire		full,empty,half_full,overflow;


integer i;


fifo	
	FIFO(    .clk(clock),
		 .rst_n(rst_n),
		 .w_en(w_en),
		 .data_w(in_data),
		 .r_en(r_en),
		 .data_r(out_data),
		 .empty(empty),
		 .full(full),
		 .half_full(half_full),
		 .overflow(overflow));

initial//test signals status  after reset(full empty half_full)
begin
	in_data=0;
	r_en=0;
	w_en=0;
	clock=1;
	rst_n=0;
	i=1;
	#25 rst_n=1;
	
	$display("\n\ninitial done\n\n");
	if({empty,half_full,full,overflow}!=4'b1000)
	begin
		$display("\nerror at time %0t:",$time);
		$display("after reset,status not asserted\n");
		$display("empty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
		$stop;
	end
	else
	begin
		$display("initial status right\nempty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
	end
   #25;
	//causing half_full
	for (i=1;i<9;i=i+1)
	begin
	   @(negedge clock) w_en=1; in_data=i;
		$display("storing %d  w_en=%d r_en=%d\n",i,w_en,r_en);
	end
	@(negedge clock) w_en=0;
	#10;
	if({empty,half_full,full,overflow}!=4'b0100)
	begin
		$display("\nerror at time %0t:",$time);
		$display("half_full\n");
		$display("empty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
		$stop;
	end
	else
	begin
		$display("half_full status right\nempty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
	end


	//causing full
	for (i=9;i<17;i=i+1)
	begin
	   @(negedge clock) w_en=1;in_data=i; 
		$display("storing %d  w_en=%d r_en=%d\n",i,w_en,r_en);
	end
	@(negedge clock) w_en=0;
	#25;
	if({empty,half_full,full,overflow}!=4'b0010)
	begin
		$display("\nerror at time %0t:",$time);
		$display("full\n");
		$display("empty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
		$stop;
	end
	else
	begin
		$display("full status right\nempty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
	end

	//causing overflow
	begin
	   @(negedge clock) w_en=1;in_data = 99;
		$display("storing %d  w_en=%d r_en=%d\n",i,w_en,r_en);
	end
	#25;
	if({empty,half_full,full,overflow}!=4'b0011)
	begin
		$display("\nerror at time %0t:",$time);
		$display("overflow\n");
		$display("empty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
		$stop;
	end
	else
	begin
		$display("overflow status right\nempty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
	end
	//these nums r in fifo 1~16
	//starting to read nums
	@(negedge clock) w_en=0;r_en=1;
	for (i=1;i<5;i=i+1)
	begin
	   @(negedge clock) r_en = (i == 4) ? 0 : 1;
		$display("reading data %d, your data %d\n",i,out_data);
		if(out_data!=i)
		begin
			$display("expected data %d\n your data %d",i,out_data);
		$stop;
		end
	end

	#25;
	if({empty,half_full,full,overflow}!=4'b0000)
	begin
		$display("\nerror at time %0t:",$time);
		$display("empty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
		$stop;
	end
	else
	begin
		$display("after reading 4 data, right, empty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
	end
	
	//these nums r in fifo 5~16
	//write again, fifo becomes 5~16,1,2,3,4
	@(negedge clock) r_en=0;
	#25;
	for (i=1;i<5;i=i+1)
	begin
	   @(negedge clock) w_en=1;in_data=i;
		$display("storing %d again  w_en=%d r_en=%d\n",i,w_en,r_en);
	end

	//read fifo all out
	@(negedge clock) w_en=0; r_en=1;	
	for (i=5;i<17;i=i+1)
	begin
	   @(negedge clock) r_en = (i == 16) ? 0 : 1;
		$display("reading data %d   %d\n",i,out_data);		
		if(out_data!=i)
		begin
			$display("date stored in %d maybe wrong\n",out_data);
			$stop;
		end	
	end

	@(negedge clock) w_en=0; r_en=1;	
	for (i=1;i<5;i=i+1)
	begin
	   @(negedge clock) r_en = (i == 4) ? 0 : 1;
		$display("reading data %d  %d\n",i,out_data);
		if(out_data!=i)
		begin
			$display("date stored in %d maybe wrong\n",i);
			$stop;
		end
	end

	#25;
	if({empty,half_full,full,overflow}!=4'b1000)
	begin
		$display("\nerror at time %0t:",$time);
		$display("empty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
		$stop;
	end
	else
	begin
		$display("********************\ndone, without error\n********************\n");
		$stop;
	end
end



always #5 clock=~clock;



endmodule


