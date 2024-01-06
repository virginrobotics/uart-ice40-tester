module top (
    input hwclk,

    output led,

    output ftdi_tx
);

//12MHz to 9600Hz
parameter baud_period = 625 ;
reg [31:0] cntr9600 = 32'h0;
reg baud_clk = 0;

wire tx_en;
reg [7:0] load_byte;
wire load;
wire ready;

always @(posedge hwclk) begin
    
    cntr9600 <= cntr9600 + 1;
    if (cntr9600 == baud_period) begin
        baud_clk <= ~baud_clk;
        cntr9600 <= 32'h0;
    end

end

//uart_tx u1(.clk(baud_clk), .ftdi_tx(ftdi_tx));

//uart fsm
uart_fsm #(
    .DATA_WIDTH(8)
) uart_hello (
    .clk(baud_clk),
    .rst_n(1'b1),
    .tx_en(tx_en),
    .load_byte(load_byte),
    .load(load),
    .ready(ready),
    .ftdi_tx(ftdi_tx)
);


assign tx_en = 1;

assign led = baud_clk;

endmodule