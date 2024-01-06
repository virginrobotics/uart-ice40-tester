module uart_tx (
    input clk,

    output ftdi_tx
);

parameter START = 4'h0, BIT1 = 4'h1, BIT2 = 4'h2, BIT3 = 4'h3, BIT4 = 4'h4, BIT5 = 4'h5, BIT6 = 4'h6, BIT7 = 4'h7, BIT8 = 4'h8, STOP = 4'h9;
parameter FEED = 4'ha;
reg [3:0] state = 4'h0, next_state;

reg [7:0] tx_byte = 8'b01000111;
reg [7:0] feed_byte = 8'b01000111;
reg chr_tog = 1'b0;

always @(posedge clk) begin
    state <= next_state;
end



always @(*) begin
    case (state)
    START: begin 
        ftdi_tx = 1'b0;
        tx_byte = feed_byte;
        next_state = BIT1;
    end
    BIT1: begin ftdi_tx = tx_byte[0];
        next_state = BIT2;
    end
    BIT2: begin ftdi_tx = tx_byte[1];
        next_state = BIT3;
    end
    BIT3: begin ftdi_tx = tx_byte[2];
        next_state = BIT4;
    end
    BIT4: begin ftdi_tx = tx_byte[3];
        next_state = BIT5;
    end
    BIT5: begin ftdi_tx = tx_byte[4];
        next_state = BIT6;
    end
    BIT6: begin ftdi_tx = tx_byte[5];
        next_state = BIT7;
    end
    BIT7: begin ftdi_tx = tx_byte[6];
        next_state = BIT8;
    end
    BIT8: begin ftdi_tx = tx_byte[7];
        next_state = STOP;
    end
    STOP: begin ftdi_tx = 1'b1;
        next_state = START;
        chr_tog = ~chr_tog;
    end
    default: next_state = START;

    endcase

end

endmodule