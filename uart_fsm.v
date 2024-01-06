// uart tx module

module uart_fsm #(
    parameter DATA_WIDTH = 8
) (
    input                           clk,
    input                           rst_n,
    input                           tx_en,
    input   [DATA_WIDTH-1:0]        load_byte,
    input                           load,
    output                          ready,
    output                          ftdi_tx
);

parameter START = 4'h0, BIT1 = 4'h1, BIT2 = 4'h2, BIT3 = 4'h3, BIT4 = 4'h4, BIT5 = 4'h5, BIT6 = 4'h6, BIT7 = 4'h7, BIT8 = 4'h8, STOP = 4'h9;
parameter FEED = 4'ha;
reg [3:0] state = 4'h0, next_state;

reg [DATA_WIDTH-1:0] tx_byte = 8'b01000111;
reg [DATA_WIDTH-1:0] feed_byte = 8'b01000111;

// feed tray fill logic
always @(posedge clk) begin
    if (ready & load) begin
        feed_byte <= load_byte;
    end else begin
        feed_byte <= 8'b00110011;
    end
end


always @(posedge clk) begin
    if (!rst_n) begin
        state <= START;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    if (tx_en) begin
        case (state)
            START: begin 
                //start bit -> 0
                ftdi_tx = 1'b0;
                //ingest feed_byte
                tx_byte = feed_byte;
                //assert ready low to prevent feed_byte change
                ready = 1'b0;
                //move to data tx state
                next_state = BIT1;
            end
            BIT1: begin 
                ftdi_tx = tx_byte[0];
                next_state = BIT2;
            end
            BIT2: begin 
                ftdi_tx = tx_byte[1];
                next_state = BIT3;
            end
            BIT3: begin 
                ftdi_tx = tx_byte[2];
                next_state = BIT4;
            end
            BIT4: begin 
                ftdi_tx = tx_byte[3];
                next_state = BIT5;
            end
            BIT5: begin 
                ftdi_tx = tx_byte[4];
                next_state = BIT6;
            end
            BIT6: begin 
                ftdi_tx = tx_byte[5];
                next_state = BIT7;
            end
            BIT7: begin 
                ftdi_tx = tx_byte[6];
                next_state = BIT8;
            end
            BIT8: begin 
                ftdi_tx = tx_byte[7];
                next_state = STOP;
            end
            STOP: begin 
                ftdi_tx = 1'b1;
                next_state = START;
                ready = 1'b1;
            end
            default: begin
                next_state = START;
                ready = 1'b0;
            end

            endcase
    end else begin
        ftdi_tx = 1'b0;
    end
end
    
endmodule