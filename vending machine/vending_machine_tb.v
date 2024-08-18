// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_Vending_FSM;

    // Inputs
    reg clk;
    reg rst;
    reg [1:0] coin;

    // Outputs
    wire product;
    wire change;

    // Instantiate the Vending_FSM module
    Vending_FSM uut (
        .clk(clk),
        .rst(rst),
        .coin(coin),
        .product(product),
        .change(change)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns period, 100 MHz clock
    end

    // Stimulus block
    initial begin
        // Initialize inputs
        rst = 1;
        coin = 0;
        #20;
        
        // Apply reset
        rst = 0;
        
        // Test sequence
        #10 coin = 2'b01; // Insert 1 rupee coin
        #10 coin = 2'b01; // Insert another 1 rupee coin
        #10 coin = 2'b00; // No coin
        #10 coin = 2'b10; // Insert 2 rupee coin
        #10 coin = 2'b00; // No coin
        #10 coin = 2'b01; // Insert 1 rupee coin
        #10 coin = 2'b10; // Insert 2 rupee coin
        #10 coin = 2'b00; // No coin

        // End simulation
        #50 $stop;
    end

    // Monitor changes
    initial begin
        $monitor("Time = %0t : coin = %b, product = %b, change = %b, state = %b",
                 $time, coin, product, change, uut.pr_state);
    end

endmodule
