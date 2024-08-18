// Code your design here
// Code your design here
module abs_of_x(x,absx);
  input[1:0] x;
  output reg absx;
  always @(*) begin
    if(x==2'b11 | x==2'b01)
      absx=1;
    else
      absx=0;
  end
endmodule
module sign_of_x(x,signx);
  input[1:0] x;
  output reg signx;
  always @(*) begin
    if(x==2'b11)
      signx=1;
    else
      signx=0;
  end
endmodule
module sign_of_ci(x1,x2,signc);
  input[1:0] x1,x2;
  output signc;
  wire signx1,signx2,absx1;
  sign_of_x m1(x1,signx1);
  sign_of_x m2(x2,signx2);
  abs_of_x m3(x1,absx1);
  assign signc=(signx1)|((!absx1)&signx2);
endmodule
module GPA(xip1,xi,xim1,xim2,G,P,A);
  input[1:0] xi,xip1,xim1,xim2;
  output G,P,A;
  wire absxi,absxip1,signxi,signci;
  abs_of_x m1(xi,absxi);
  abs_of_x m2(xip1,absxip1);
  sign_of_x m3(xi,signxi);
  sign_of_ci m4(xim1,xim2,signci);
  assign G=(absxip1 & absxi) & ~(signxi ^ signci);
  assign P=(absxip1 ^ absxi) & (~(signxi ^ signci) | ~(absxi));
  assign A=(absxip1) & (absxi) & (signxi ^ signci);
endmodule


module GiiPiiAii(x,G,P,A);
  input[19:0] x;
  output [10:0] G[10:0],P[10:0],A[10:0];
  wire[1:0] xm1,xm2,xi;
  assign xm1=2'b00;
  assign xm2=2'b00;
  assign xi=2'b00;
  GPA k1(x[3:2],x[1:0],2'b00,2'b00,G[0][0],P[0][0],A[0][0]);
  GPA K2(x[5:4],x[3:2],x[1:0],2'b00,G[1][1],P[1][1],A[1][1]);
  GPA K3(x[7:6],x[5:4],x[3:2],x[1:0],G[2][2],P[2][2],A[2][2]);
  GPA K4(x[9:8],x[7:6],x[5:4],x[3:2],G[3][3],P[3][3],A[3][3]);
  GPA K5(x[11:10],x[9:8],x[7:6],x[5:4],G[4][4],P[4][4],A[4][4]);
  GPA K6(x[13:12],x[11:10],x[9:8],x[7:6],G[5][5],P[5][5],A[5][5]);
  GPA K7(x[15:14],x[13:12],x[11:10],x[9:8],G[6][6],P[6][6],A[6][6]);
  GPA K8(x[17:16],x[15:14],x[13:12],x[11:10],G[7][7],P[7][7],A[7][7]);
  GPA K9(x[19:18],x[17:16],x[15:14],x[13:12],G[8][8],P[8][8],A[8][8]);
  
//  genvar p;
//  generate
//    for(p=10;p>2;p=p-1'd1) begin:GPA_instance
//      GPA m(x[2*p+1'd1:2*p],x[2*p-1'b1:2*p-2'd2],x[2*p-2'd3:2*p-3'd4],x[2*p-3'd5:2*p-3'd6],G[p-1],P[p-1],A[i-1]);
//    end:GPA_instance
//  endgenerate
endmodule


//module gpa(G,P,A,g,p);
//  input G,P,A;
//  output g,p;
//  assign g = G | A;
//  assign p = P | A;
//endmodule

//module gp_modified(xi,xip1,xim1,xim2,g,p);
//  input[1:0] xi,xip1,xim1,xim2;
//  output g,p;
//  wire G,P,A;
//  GPA m1(xi,xip1,xim1,xim2,G,P,A);
//  gpa m2(G,P,A,g,p);
//endmodule


module gp_ii(x,g,p);
  input[19:0] x;
  output reg [10:0] g[10:0],p[10:0];
  wire[10:0] G[10:0],P[10:0],A[10:0];
  GiiPiiAii m(x,G,P,A);
  always @(*) begin
    for(int i=0; i<10 ; i++) begin
      g[i][i] = G[i][i] | A[i][i];
      p[i][i] = P[i][i] | A[i][i];
    end
  end
endmodule


module gp_ij(x,go,po);
  input[19:0] x;
  output reg [10:0] go[10:0],po[10:0];
  wire[10:0] ig[10:0],ip[10:0];
  int i=4'd9;
  int k,j;
  gp_ii m(x,ig,ip);
  always @(*) begin
    for(k=0; k<i; k++) begin
      go[k][k]=ig[k][k];
      po[k][k]=ip[k][k];
    end
  end
  always @(*) begin
    for(int p=1; p<i ; p++) begin
      for(j=i-p-1; j>-1; j=j-1'b1) begin
        go[i-p][j] = go[i-p][j+1] ^ (po[i-p][j+1] & go[j][j]);
        po[i-p][j] = po[i-p][j+1] & po[j][j];
      end
    end
  end
endmodule



module mod_ci_new(x,mag_of_c);
  input[19:0] x;
  output reg [8:0] mag_of_c;
  wire[10:0] g[10:0],p[10:0];
  gp_ij m(x,g,p);
  wire co;
  assign co=1'b0;
  int i=4'd9;
  always @(*) begin
    mag_of_c[0]=1'b0;
    for(int k=i-1; k>0; k=k-1'b1) begin
      mag_of_c[k] = (p[k-1][0] & co) ^ (g[k-1][0]);
    end
  end
endmodule


module CSD_out(x,mag_of_y,sign_of_y);
  input[19:0] x;
  output reg [8:0] mag_of_y,sign_of_y;
  wire[8:0] mag_of_c,signc;
  wire[9:0] absx,signx;
  mod_ci_new m(x,mag_of_c);
  genvar i;
  generate
    for(i=0; i<10; i++) begin:name1
      abs_of_x m1({x[2*i+1],x[2*i]},absx[i]);
    end:name1
  endgenerate
  genvar p;
  generate
    for(p=0; p<10; p++) begin:name2
      sign_of_x m2({x[2*p+1],x[2*p]},signx[p]);
    end:name2
  endgenerate
  sign_of_ci h1(2'b00,2'b00,signc[0]);
  sign_of_ci h2({x[1],x[0]},2'b00,signc[1]);
  genvar q;
  generate
    for(q=2; q<9; q++) begin:name3
      sign_of_ci m3({x[2*q-1],x[2*q-2]},{x[2*q-3],x[2*q-4]},signc[q]);
    end:name3
  endgenerate
  always @(*) begin
    for(int k=0; k<9; k++) begin
      mag_of_y[k] = mag_of_c[k] ^ absx[k];
      sign_of_y[k]=(mag_of_c[k]^absx[k])&(absx[k+1]^((signc[k]&!absx[k])|(signx[k]&absx[k])));
    end
  end
endmodule
