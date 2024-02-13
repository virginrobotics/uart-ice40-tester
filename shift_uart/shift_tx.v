module shift_tx #(
    parameter FRAME_WIDTH = 10,
    parameter SHIFT_AMOUNT = 10    
) (
    input   wire                       baud_clk,
    input   wire                       send_en,
    input   wire   [FRAME_WIDTH-1:0]   data_frame,
    output  wire                       ftdi_tx,
    output  wire                       frame_sent
);

    // Shift out logic
    
    //reg [FRAME_WIDTH-1:0] data_frame = 10'b1010000010;// G in ASCII is 01000111, we send the LSB first in UART (i guess)
    reg [FRAME_WIDTH-1:0] tray = 10'b0;
    reg [5:0] shift_count = 0;
    reg ftdi_tx_gg = 0;


    assign ftdi_tx = ftdi_tx_gg;

    always @(posedge baud_clk) begin
        if (shift_count == SHIFT_AMOUNT-1) begin
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