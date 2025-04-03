module uart_test_top #(
    parameter   ADDR_WIDTH = 8,
    parameter   DATA_WIDTH = 8
) (
    input   wire    clk,
    input   wire    rst_n,

    input   wire    en,
    
    output  wire    uart_tx
);
    
    wire [ADDR_WIDTH-1:0]   mem_addr;
    wire [DATA_WIDTH-1:0]   mem_data;
    wire [DATA_WIDTH-1:0]   tx_data;

    wire mem_rd;
    wire tx_done;
    wire tx_busy;
    wire tx_start;



    // word rom instantiation
    word_rom rom (
        .clk(clk),
        .rst_n(rst_n),
        .addr(mem_addr),
        .rd_en(mem_rd),
        .rd_data(mem_data)
    );

    // seq_gen control module
    seq_gen seq_control (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .tx_done(tx_done),
        .tx_busy(tx_busy),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .mem_data(mem_data), // Not used in this test
        .mem_addr(mem_addr),
        .mem_rd(mem_rd)
    );

    // UART transmitter
    uart_top tx_mod (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(tx_data),
        .start(tx_start),
        .uart_tx(uart_tx),
        .done(tx_done),
        .uart_busy(tx_busy)
    );



endmodule