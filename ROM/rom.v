// Single Port ROM -> Read only
module rom(clk_i,rst_i,addr_i,en_i,rdata_o);
parameter SIZE=1024;//1Kb
parameter WIDTH=16;//16 bits
parameter DEPTH=SIZE/WIDTH;//64 locations
parameter ADDR_WIDTH=$clog2(DEPTH);
integer i;
input clk_i,rst_i,en_i;
input [ADDR_WIDTH-1:0]addr_i;
output reg [WIDTH-1:0]rdata_o;
reg [WIDTH-1:0]mem[DEPTH-1:0];//memory

always @(posedge clk_i)
	begin
		for(i=0;i<DEPTH;i=i+1)
				mem[i]=i;
	end

always@(posedge clk_i)
	begin
		if(rst_i)
			begin
				rdata_o=0;	
				for(i=0;i<DEPTH;i=i+1)
					mem[i]=0;
			end
		else
			if(en_i)
				rdata_o<=mem[addr_i];//read operation
			else
				rdata_o<=rdata_o;
	end
endmodule

