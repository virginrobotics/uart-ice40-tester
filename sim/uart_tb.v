`timescale 1ns/1ps

module uart_tb;

    reg clk;
    reg rst_n;
    reg [7:0] data_in;
    reg start;
    wire uart_tx;
    wire done;

    // Instantiate the UART transmitter module
    uart_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .start(start),
        .uart_tx(uart_tx),
        .done(done)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns clock period (100MHz)

    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        data_in = 8'h00;
        start = 0;

        // Apply reset
        #20 rst_n = 1;
        
        // Send a byte
        #10 data_in = 8'hA5; // Example data
        start = 1;
        #10 start = 0;
        
        // Wait for transmission to complete
        wait (done);
        
        // Send another byte
        #50 data_in = 8'h3C;
        start = 1;
        #10 start = 0;
        
        // Wait for second transmission to complete
        wait (done);
        
        // End simulation
        #100 $finish;
    end

    // Monitor outputs
    initial begin
        $dumpfile("uart_tb.vcd");
        $dumpvars(0, uart_tb);
        $monitor($time, " Data: %h, Start: %b, TX: %b, Done: %b", data_in, start, uart_tx, done);
    end

endmodule
