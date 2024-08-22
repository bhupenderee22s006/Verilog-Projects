// Gate-Level Module to find the sum in full adder
module sumFA(s,x,y,z);
input wire x,y,z;
output wire s;
wire s1;
xor x1(s1,x,y);
xor x2(s,s1,z);
endmodule

// Gate-Level Module to find the carry in full adder
module carryFA(c,x,y,z);
input wire x,y,z;
output wire c;
wire c1,c2,c3;
and a1(c1,x,y);
xor x1(c2,x,y);
and a2(c3,c2,z);
or o1(c,c1,c3);
endmodule

// Full adder module based on gate-level modelling that utilizes above two modules
module FA(s,c,x,y,z);
input wire x,y,z;
output wire s,c;
sumFA s1(s,x,y,z);
carryFA c1(c,x,y,z);
endmodule

// Gate-Level Module for sum of two inputs
module sumHA(s,a,b);
input a,b;
output s;
xor x1(s,a,b);
endmodule

// Gate-Level Module for carry of two inputs
module carryHA(c,a,b);
input a,b;
output c;
and a1(c,a,b);
endmodule

// Gate-Level Module that uses above modules to find sum and carry
module HA(a,b,s,c);
input a,b;
output s,c;
sumHA s1(s,a,b);
carryHA c1(c,a,b);
endmodule

module wallace_multiplier(m,a,b);
input [3:0] a,b;
output [7:0] m;

wire [3:0] p0,p1,p2,p3;
wire [4:0] s,c,c1;
wire k1,l1,k2,l2;

assign p0[0] = (a[0])&(b[0]);
assign p0[1] = (a[1])&(b[0]);
assign p0[2] = (a[2])&(b[0]);
assign p0[3] = (a[3])&(b[0]);

assign p1[0] = (a[0])&(b[1]);
assign p1[1] = (a[1])&(b[1]);
assign p1[2] = (a[2])&(b[1]);
assign p1[3] = (a[3])&(b[1]);

assign p2[0] = (a[0])&(b[2]);
assign p2[1] = (a[1])&(b[2]);
assign p2[2] = (a[2])&(b[2]);
assign p2[3] = (a[3])&(b[2]);

assign p3[0] = (a[0])&(b[3]);
assign p3[1] = (a[1])&(b[3]);
assign p3[2] = (a[2])&(b[3]);
assign p3[3] = (a[3])&(b[3]);

HA h0(p2[1],p3[0],k1,l1);
HA h1(p2[2],p3[1],k2,l2);

HA h2(p0[1],p1[0],s[0],c[0]);
FA f0(s[1],c[1],p0[2],p1[1],p2[0]);
FA f1(s[2],c[2],p0[3],p1[2],k1);
FA f2(s[3],c[3],k2,p1[3],l1);
FA f3(s[4],c[4],l2,p3[2],p2[3]);

assign m[0] = p0[0];
assign m[1] = s[0];
FA f4(m[2],c1[0],s[1],c[0],1'b0);
FA f5(m[3],c1[1],s[2],c[1],c1[0]);
FA f6(m[4],c1[2],s[3],c[2],c1[1]);
FA f7(m[5],c1[3],s[4],c[3],c1[2]);
FA f8(m[6],c1[4],p3[3],c[4],c1[3]);
assign m[7] = c1[4];

endmodule

module Clk_Div(inClk,outClk);

input inClk;
output reg outClk;
reg [23:0] clockCount;
initial begin
    clockCount = 24'd1; outClk = 1'b0;
end
always @(posedge inClk) begin
             clockCount=clockCount+1;
           if(clockCount == 24'd2500000) begin
               clockCount = 24'd1;
               outClk = ~outClk;
             end
          end

endmodule
// Verilog code for simple LCD display to display product obtained in above Wallace Multiplier

module wallace_lcd(a , b , in_Clk, lcd_rs, lcd_e, data);
  input [3:0] a,b;
  input in_Clk;
  output reg [7:0] data;
  output reg lcd_rs;
  output lcd_e;
 
  wire [7:0] m;
  wire [7:0] command [0:5];
  reg [31:0] count = 0;
  wire out_Clk;
  wire [7:0] hundreds, tens , units;
 
  wallace_multiplier w0(m,a,b);

  assign hundreds = (m / 100) + 8'h30;
  assign tens = ((m % 100) / 10) + 8'h30;
  assign units = (m % 10) + 8'h30;

  assign command [0] = 8'h38; // control signal to display on two lines
  assign command [1] = 8'h0C; // keep display on but cursor off
  assign command [2] = 8'h06; // increment the cursor
  assign command [3] = 8'h01; // clear the display
  assign command [4] = 8'hC0; // choose the second line
  assign command [5] = 8'h80; // choose the first line

  Clk_Div(in_Clk, out_Clk);
  assign lcd_e = out_Clk;

  always@(posedge lcd_e) begin
    count = count + 1;

    case(count)
        1: begin lcd_rs = 0; data = command[0] ; end
        2: begin lcd_rs = 0; data = command[1] ; end        
        3: begin lcd_rs = 0; data = command[2] ; end
        4: begin lcd_rs = 0; data = command[3] ; end
        5: begin lcd_rs = 0; data = command[5] ; end
        6:  begin lcd_rs = 1; data =  8'h50 ; end  // 'P'
        7:  begin lcd_rs = 1; data =  8'h72 ; end // 'r'
        8:  begin lcd_rs = 1; data =  8'h6F ; end // 'o'
        9:  begin lcd_rs = 1; data =  8'h64 ; end // 'd'
        10: begin lcd_rs = 1; data =  8'h75 ; end // 'u'
        11: begin lcd_rs = 1; data =  8'h63 ; end // 'c'
        12: begin lcd_rs = 1; data =  8'h74 ; end // 't'
        13: begin lcd_rs = 1; data =  8'h20 ; end // ' '
        14: begin lcd_rs = 1; data =  8'h69 ; end // 'i'
        15: begin lcd_rs = 1; data =  8'h73 ; end // 's'
        16: begin lcd_rs = 1; data =  8'h20 ; end // ' '
        17: begin lcd_rs = 1; data =  8'h3D ; end // '='
        18: begin lcd_rs = 0; data = command[4] ; end
        19: begin lcd_rs = 1; data =  hundreds ; end // 'E'
        20: begin lcd_rs = 1; data =  tens ; end // 'F'
        21: begin lcd_rs = 1; data =  units ; count=0 ; end // 'G'
    endcase

  end
  //always@(a) begin
    //lcd_rs = 0; data = command[3] ;
    //count=0;
  //end
endmodule
