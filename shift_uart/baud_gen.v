module baud_gen #(
    parameter CNTR_W = 32,
    parameter SOURCE_CLK = 12000000,
    parameter TARGET_CLK = 9600
) (
    input   wire    hwclk,
    output  wire    baud_clk
);

    localparam N = SOURCE_CLK/TARGET_CLK;
    localparam COUNTER_PERIOD = N/2;
    
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

    
endmodule