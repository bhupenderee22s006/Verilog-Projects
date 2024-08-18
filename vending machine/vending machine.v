// Code your design here
module Vending_FSM(
  input clk,
  input rst,
  input[1:0]coin,  // as we can only insert the 1 and 2 rupee coins only so we can write 2 in 2 bits 
  output reg product,
  output reg change);
  
  
  parameter ideal = 3'b000,rs1 = 3'b001,rs2 = 3'b010,rs3 = 3'b011,rs4 = 3'b100;
  
  reg [3:0] pr_state;
  reg [3:0] nxt_state;
  reg [2:0] count =0;
  
  always @(posedge clk)begin
    if(rst)begin
      count = 0;
      pr_state = ideal;
    end
    else begin
      count = count +1;
      pr_state = nxt_state;
    end
  end
  
  always@(pr_state,coin,count)begin
    case(pr_state)
      
      ideal:begin
        product = 0;
        change =0;
        if(coin==1)
          nxt_state  = rs1;
        else if(coin==2)
          nxt_state = rs2;
        else 
          nxt_state = ideal;
      end
      
        
        rs1:begin
           product = 0;
           change =0;
           if(coin==1)
             nxt_state  = rs2;
           else if(coin==2)
             nxt_state = rs3;
           else begin
             if(count==4)
             nxt_state = ideal;
             else
               nxt_state = rs1;
           end
        end
      
      rs2:begin
          product = 0;
           change =0;
           if(coin==1)
             nxt_state  = rs3;
           else if(coin==2)
             nxt_state = rs4;
           else begin
             //just to check if it has crosed the 4 clk cycles without getting the coin 
             if(count==4)
             nxt_state = ideal;
             else
               //if not crossed then asked to remain the same state 
               nxt_state = rs2;
           end
      end
      
      rs3:begin nxt_state = ideal; product  = 1;change = 0;
      end
      
      rs4:begin nxt_state = ideal; product  = 1;change = 1;
      end
      
    endcase
  end
  
endmodule