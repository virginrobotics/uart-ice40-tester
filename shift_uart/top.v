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

    parameter TARGET_CLK1HZ = 1;

    // Shift out logic
    localparam FRAME_WIDTH = 8; //10
    localparam SHIFT_AMOUNT = 9;// 8 doesn't work because shift_amount == SHIFT_AMOUNT-1 not < - i guess


    wire frame_sent;
    reg [FRAME_WIDTH-1:0] data_frame = 8'b01001000;
    
    wire baud_clk;
    wire one_hz;

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


    // One Hz send_en generator
    baud_gen #(
    .CNTR_W(CNTR_W),
    .SOURCE_CLK(SOURCE_CLK),
    .TARGET_CLK(TARGET_CLK1HZ)
    ) baud_gen_one_hz (
        // ref clk
        .hwclk(hwclk),
        // baud clk out
        .baud_clk(one_hz)
    );

    // Send enable pulse generator from 1 Hz clock
    reg one_hz_reg;
    wire send_en_pulse;
    always @(posedge baud_clk) begin
        one_hz_reg <= one_hz;        
    end

    assign send_en_pulse = one_hz & !one_hz_reg;

    assign led1 = one_hz;
    assign led2 = frame_sent;

    // Shift register based basic UART 8n1 transmitter

    shift_tx_fsm #(
        .FRAME_WIDTH(FRAME_WIDTH),
        .SHIFT_AMOUNT(SHIFT_AMOUNT)
    ) uart_tx_inst (
        .baud_clk(baud_clk),
        .send_en(send_en_pulse),
        .data_frame(data_frame),
        .ftdi_tx(ftdi_tx),
        .frame_sent(frame_sent)
    );
    

    
    
endmodule
