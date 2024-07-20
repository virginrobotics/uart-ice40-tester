`timescale 1ns / 1ps

module tb_tx_sr;

    // Parameters
    parameter DATA_W = 8;
    parameter FRAME_W = 10;

    // Inputs
    reg clk;
    reg enable;
    reg [DATA_W-1:0] i_data;

    // Outputs
    wire o_frame;
    wire o_txsr_empty;

    // Instantiate the Unit Under Test (UUT)
    tx_sr #(
        .DATA_W(DATA_W),
        .FRAME_W(FRAME_W)
    ) uut (
        .clk(clk),
        .enable(enable),
        .i_data(i_data),
        .o_frame(o_frame),
        .o_txsr_empty(o_txsr_empty)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period clock
    end

    // Test sequence
    initial begin
        // Initialize Inputs
        enable = 0;
        i_data = 0;

        // Wait for global reset to finish
        #50;

        // Apply test vectors
        enable = 1;
        i_data = 8'b01001000; // Example data
        #250;

        enable = 0;
        i_data = 8'h3C;
        #20;

        enable = 1;
        i_data = 8'hFF;
        #20;

        // Add more test cases as needed
        // ...

        // End of test
        #100;
        $finish;
    end

    // Dump waves for GTKWave
    initial begin
        $dumpfile("tb_tx_sr.vcd");
        $dumpvars(0, tb_tx_sr);
    end

endmodule
