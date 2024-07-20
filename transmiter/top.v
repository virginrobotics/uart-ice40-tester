// Blink an LED provided an input clock
/* module */
module top (
    input   hwclk,
    input   pb,
    output  ftdi_tx,
    //output  frame_sent,
    output  led2,
    output  led1
);
    
// Converting a 12Mhz source clock to a 9600 baud for UART
parameter CNTR_W = 32;
parameter SOURCE_CLK = 12000000;
parameter TARGET_CLK = 9600; // enter desired baud here : 4800, 9600, 115200    

wire baud_clk;

    //9600 Hz UART baud clk generator

baud_gen #(
    .CNTR_W(CNTR_W),
    .SOURCE_CLK(SOURCE_CLK),
    .TARGET_CLK(TARGET_CLK)
) baud_gen_inst (
    // ref clk
    .hwclk(hwclk),
    // baud clk out
    .baud_clk(baud_clk)
);

// Instantiate the TX Shift Register
wire [7:0] i_data = 8'b01001000;


tx_sr #(
    .DATA_W(8),
    .FRAME_W(10)
) uut (
    .clk(baud_clk),
    .enable(1'b1),
    .i_data(8'b01000000),
    .o_frame(ftdi_tx),
    .o_txsr_empty()
);
   
    assign led2 = ftdi_tx;
    
endmodule
