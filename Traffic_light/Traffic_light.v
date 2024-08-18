module tlc(clk,rst,TRED,TGREEN,TYELLOW);
parameter SIZE=8;
`ifdef BINARY
parameter RED=2'b00;
parameter GREEN=2'b01;
parameter YELLOW=2'b10; 
reg [1:0]pst,nxt;
`elsif ONEHOT
parameter RED=3'b001; 
parameter GREEN=3'b010;
parameter YELLOW=3'b100;
reg [2:0]pst,nxt;
`else
parameter RED=2'b00;
parameter GREEN=2'b01;
parameter YELLOW=2'b11;
reg [1:0]pst,nxt;
`endif

initial
	begin
		if(YELLOW==2'b10)
		$display("BINARY");
		else if(YELLOW==3'b100)
		$display("ONEHOT");
		else
		$display("GRAY");
	end

input clk,rst;
reg [SIZE-1:0]count;
output reg TRED,TGREEN,TYELLOW;

always @(posedge clk)
	begin
		if(rst)
			begin
				{TRED,TGREEN,TYELLOW}<=3'b0;
				pst<=RED;
				nxt<=RED;
				count<=0;
			end
		else
			begin
				pst<=nxt;
				count<=count+1;
			end
	end

always @(pst or count)
	begin
		case(pst)
		RED:begin
				if(count==10)
					begin
						nxt=GREEN;
						count=0;
						TRED=0;//Turning the red light off
						TGREEN=1;
					end
				else
					begin
						nxt=RED;
						TRED=1;
					end
			end
		GREEN:begin
				if(count==6)
					begin
						nxt=YELLOW;
						count=0;
						TGREEN=0;
						TYELLOW=1;
					end
				else
					begin
						nxt=GREEN;
						TGREEN=1;
					end
			  end
		YELLOW:begin
				if(count==4)
					begin
						nxt=RED;
						count=0;
						TYELLOW=0;
						TRED=1;
					end
				else
					begin
						nxt=YELLOW;
						TYELLOW=1;
					end
				end
		default : begin
					nxt=YELLOW;
				  end
		endcase

	end

endmodule




