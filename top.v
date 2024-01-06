// to test uart do following
// make all
// make burn
// sudo screen /dev/ttyUSB1 9600



module top (
    input hwclk,

    output led,

    output ftdi_tx
);

//12MHz to 9600Hz
parameter BAUD_PERIOD = 625 ;
reg [31:0] cntr9600 = 32'h0;
reg baud_clk = 0;

//12MHz to 1MHz
parameter ONEHZ_PERIOD = 6000000;
reg [31:0] cntr1hz = 32'h0;
reg clk_1hz = 0;

wire tx_en;
reg [7:0] load_byte = 8'b00110011;
wire load;
wire ready;

// 9600 uart baud generator
always @(posedge hwclk) begin 
    cntr9600 <= cntr9600 + 1;
    if (cntr9600 == BAUD_PERIOD) begin
        baud_clk <= ~baud_clk;
        cntr9600 <= 32'h0;
    end
end

// 1Hz generator
always @(posedge hwclk) begin
    cntr1hz <= cntr1hz + 1;
    if (cntr1hz == ONEHZ_PERIOD) begin
        clk_1hz <= ~clk_1hz;
        cntr1hz <= 32'h0;
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

assign load = clk_1hz;

assign tx_en = 1;

assign led = baud_clk;

endmodule