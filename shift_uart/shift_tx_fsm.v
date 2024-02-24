module shift_tx_fsm #(
    parameter FRAME_WIDTH = 10,
    parameter SHIFT_AMOUNT = 8    
) (
    input   wire                       baud_clk,
    input   wire                       send_en,
    input   wire   [FRAME_WIDTH-1:0]   data_frame,
    output  wire                       ftdi_tx,
    output  wire                       frame_sent
);

    // Shift out logic

    // View terminal uart
    // sudo screen /dev/ttyUSB1 9600

    // To-do 
    // Add state machine logic . IDLE -> START_TX -> TX_DATA -> TX_STOP -> IDLE
    
    //reg [FRAME_WIDTH-1:0] data_frame = 10'b1010000010;// G in ASCII is 01000111, we send the LSB first in UART (i guess)
    reg [FRAME_WIDTH-1:0] tray = 0;
    reg [5:0] shift_count = 0;
    reg ftdi_tx_gg = 0;


    assign ftdi_tx = ftdi_tx_gg;

    /* always @(posedge baud_clk) begin
        if (shift_count == SHIFT_AMOUNT-1) begin
            shift_count <= 0;
            tray        <= data_frame;
            ftdi_tx_gg  <= 1; 
        end else begin
            ftdi_tx_gg  <= tray[0];
            tray    <= tray >> 1; 
            shift_count <= shift_count + 1;
        end



    end */

    // FSM logic
    parameter STATE_NUM = 4;

    reg [STATE_NUM-1:0] state = 0;
    reg [STATE_NUM-1:0] next_state = 0;

    parameter  IDLE = 4'd0;
    parameter  START_TX = 4'd1;
    parameter  TX_DATA = 4'd2;
    parameter  TX_STOP = 4'd3;

    always @(posedge baud_clk ) begin

        //state <= next_state;
        
    end

    always @(posedge baud_clk) begin
        case (state)
            IDLE: begin
                if (send_en == 1'b1) begin
                    state <= START_TX;
                    tray <= data_frame;
                end else begin
                    state <= IDLE;
                    ftdi_tx_gg <= 1'b1;
                    
                end
                frame_sent <= 1'b0;
            end 

            START_TX: begin
                state <= TX_DATA;
                //tray <= data_frame;
                ftdi_tx_gg <= 1'b0;
            end

            TX_DATA: begin
                if (shift_count == SHIFT_AMOUNT-1) begin
                    state <= IDLE;
                    shift_count <= 0;
                    ftdi_tx_gg <= 1'b1;
                    frame_sent <= 1'b1;
                end else begin
                    state <= TX_DATA;
                    shift_count <= shift_count + 1;
                    ftdi_tx_gg <= tray[0];
                    tray <= tray >> 1;
                end
            end


            default: begin
                state <= IDLE;
                ftdi_tx_gg <= 1'b1;
            end 
        endcase
    end






endmodule