module tb_FSM_1101;

  reg clk;
  reg rst;
  reg in;
  wire out;

  // Instantiate the FSM module
  FSM_1101 dut (
    .clk(clk),
    .rst(rst),
    .in(in),
    .out(out)
  );

  // Clock generation
  always #5 clk = ~clk; // 10ns period clock

  initial begin
    // Initialize inputs
    clk = 0;
    rst = 0;
    in = 0;

    // Reset the FSM
    rst = 1;
    #10; // wait for 10ns
    rst = 0;
    #10;

    // Test sequence: 1101
    in = 1; #10; // state = s1
    in = 1; #10; // state = s11
    in = 0; #10; // state = s110, output should be 1
    in = 1; #10; // state = s0
    in  = 1; #10
    in = 0; #10

    

    $stop; // Stop simulation
  end
  initial begin
    $monitor("time = %0t || in = %b || out = %b || state = %b",$time,in,out,dut.state);
  end
endmodule
