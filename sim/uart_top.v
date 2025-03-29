module uart_top #(
    parameter DATA_WIDTH = 8
) (
    input   wire    clk,
    input   wire    rst,
    
    input   wire [DATA_WIDTH-1:0]    data_in,
    input   wire    start,

    output  wire    uart_tx,
    output  wire    done 
);


    
endmodule