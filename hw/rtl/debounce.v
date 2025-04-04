module debounce (
    input   wire clk,
    input   wire d_in, //pb0
    output  reg d_out
);

    reg debouncing = 1'b0;
    reg [31:0] count = 32'b0;
    localparam TSHOLD = 32'd12000;
    reg led_val;
    reg pulse = 0;

    always @(posedge clk) begin
        if (~debouncing && ~d_in) begin
            led_val <= ~led_val;
            debouncing <= 1;
            pulse <= 1;
        end else if (debouncing && ~d_in) begin
            count <= 32'b0;
            pulse <= 0;
        end else if (debouncing && count < TSHOLD) begin
            count <= count + 1;
            pulse <= 0;
        end else if (debouncing) begin
            count <= 32'b0;
            debouncing <= 0;
            pulse <= 0;
        end
    end

    assign d_out = ~pulse;
    
endmodule