// Blink an LED provided an input clock
/* module */
module top (hwclk, led1, led2, led3, led4, led5, led6, led7, led8, pb0, ftdi_tx);
    /* I/O */
    input hwclk;
    output led1;
    output led2;
    output led3;
    output led4;
    output led5;
    output led6;
    output led7;
    output led8;
    input  pb0;
    output ftdi_tx;


    wire pb0_debounced;
    wire rst_n;
    wire baud_clk;
    wire uart_tx;

    SB_IO #(
        .PIN_TYPE(6'b0000_01),
        .PULLUP(1'b1)
    ) push_button_in (
        .PACKAGE_PIN(pb0),
        .D_IN_0(pb0_debounced)
    );

    debounce rst_button (
        .clk(baud_clk),
        .d_in(pb0_debounced),
        .d_out(rst_n)
    );
    

    // Converting a 12Mhz source clock to a 9600 baud for UART
    parameter CNTR_W = 32;
    parameter SOURCE_CLK = 12000000;
    parameter TARGET_CLK = 9600; // enter desired baud here : 4800, 9600, 115200

    // baud clock generator 
    // 9600 Hz UART baud clk generator

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



    // Message transmitter
    uart_test_top msg_transmitter (
    .clk(baud_clk),
    .rst_n(rst_n),
    .en(1'b1),
    .uart_tx(uart_tx)
    );

    assign ftdi_tx = uart_tx;
    assign led1 = rst_n;
    assign led2 = baud_clk;
    assign led3 = uart_tx;




endmodule
