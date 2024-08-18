`include "rom.v"

module tst;
parameter SIZE=1024;
parameter WIDTH=16;
parameter DEPTH=SIZE/WIDTH;
parameter ADDR_WIDTH=$clog2(DEPTH);

reg clk_i,rst_i,en_i;
reg [ADDR_WIDTH-1:0]addr_i;
wire [WIDTH-1:0]rdata_o;
integer i;
rom #(.SIZE(SIZE),.WIDTH(WIDTH),.DEPTH(DEPTH),.ADDR_WIDTH(ADDR_WIDTH))dut(.*);

initial
	clk_i=0;
always 
	#5 clk_i=~clk_i;


initial
	begin
		rst_i=1;
		#20;
		rst_i=0;
		en_i=0;
		//$readmemh("image.hex",dut.mem);
		//$writemem("out.hex",dut.mem);//reading out
		for(i=0;i<DEPTH;i=i+1)
			begin
			addr_i=i;
			en_i=1;
			#10;
			$display("rst=%b,en_i=%b,addr_i=%0d,rdata_o=%0d",rst_i,en_i,addr_i,rdata_o);
			end
			addr_i=0;
			en_i=0;
		#700 $finish;
	end

endmodule
