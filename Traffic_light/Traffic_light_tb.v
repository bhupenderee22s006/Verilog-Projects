`include "tlc.v"
module tst;
parameter SIZE=8;
reg clk,rst;
wire TRED,TGREEN,TYELLOW;
wire [SIZE-1:0]count;
tlc dut(clk,rst,TRED,TGREEN,TYELLOW);

initial
	begin
		clk=0;
		forever
			#5 clk=~clk;
	end


initial
	begin
		$monitor("rst=%b,TRED=%b,TGREEN=%b,TYELLOW=%b",rst,TRED,TGREEN,TYELLOW);
		rst=1;
		#20;
		rst=0;
	end

initial
	#2000 $finish;

endmodule

