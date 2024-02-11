// Blink an LED provided an input clock
/* module */
module top (
    input   hwclk,
    input   pb,
    output  ftdi_tx
);
    // Converting a 12Mhz source clock to a 9600 baud for UART
    parameter CNTR_W = 32;
    parameter SOURCE_CLK = 12000000;
    parameter TARGET_CLK = 9600; // enter desired baud here : 4800, 9600, 115200 

    parameter N = SOURCE_CLK/TARGET_CLK;
    parameter COUNTER_PERIOD = N/2;

    // clock registers
    reg [CNTR_W-1:0] counter = 0;
    reg baud_clk = 0;

    // baud clk generator
    always @(posedge hwclk) begin

        counter <= counter + 1'b1;

        if (counter == COUNTER_PERIOD) begin
            counter <= 32'b0;
            baud_clk <= ~baud_clk;
        end 
    end

    // Shift out logic
    localparam FRAME_WIDTH = 10;
    localparam SHIFT_AMOUNT = 10;
    reg [FRAME_WIDTH-1:0] data_frame = 10'b1010000010;// G in ASCII is 01000111, we send the LSB first in UART (i guess)
    reg [FRAME_WIDTH-1:0] tray = 10'b0;
    reg [5:0] shift_count = 0;
    reg ftdi_tx_gg = 0;

    assign ftdi_tx = ftdi_tx_gg;

    always @(posedge baud_clk) begin

        if (shift_count == 9) begin
            shift_count <= 0;
            tray        <= data_frame;
            ftdi_tx_gg  <= 1; 
        end else begin
            ftdi_tx_gg  <= tray[0];
            tray    <= tray >> 1; 
            shift_count <= shift_count + 1;
        end
        
        
        
    end

    
    
endmodule
