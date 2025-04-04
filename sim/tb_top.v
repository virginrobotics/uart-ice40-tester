// Simulation steps
// iverilog -o uart_tb uart_top.v seq_gen.v word_rom.v uart_test_top.v uart_tb.v
// vvp tb_top_dump
// gtkwave tb_top.vcd &



module tb_top;

reg clk;
reg rst_n;
reg en;
wire uart_tx;

uart_test_top top (
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .uart_tx(uart_tx)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Reset and enable
initial begin
    $dumpfile("tb_top.vcd");
    $dumpvars(0, tb_top);

    rst_n = 0;
    en = 0;
    #20;
    rst_n = 1;
    #10;
    en = 1;
    #4000; // Allow time for transmission
    $finish;
end

// UART capture and verification
/*
initial begin
    reg [7:0] received_data;
    integer i;
    reg [7:0] expected [0:13] = {
        8'h48, 8'h65, 8'h6C, 8'h6C, 8'h6F, 
        8'h20, 8'h57, 8'h6F, 8'h72, 8'h6C, 
        8'h64, 8'h20, 8'h21, 8'h0A
    };

    wait (en === 1'b1);
    for (i = 0; i < 14; i = i + 1) begin
        capture_uart(received_data);
        $display("Received: 0x%h ('%s') | Expected: 0x%h ('%s') %s",
            received_data, ascii(received_data),
            expected[i], ascii(expected[i]),
            (received_data === expected[i]) ? "correct" : "wrong");
    end
end

// Task to capture UART frame
task capture_uart;
    output [7:0] data;
    begin
        // Wait for start bit
        @(negedge uart_tx);
        // Sample data bits at each clock edge (LSB first)
        for (int i = 0; i < 8; i = i + 1) begin
            @(posedge clk);
            data[i] = uart_tx;
        end
        // Verify stop bit
        @(posedge clk);
        if (uart_tx !== 1'b1) $display("Error: Stop bit not high at time %t", $time);
    end
endtask

// Helper function to convert ASCII to character
function string ascii(input [7:0] val);
    if (val inside {[8'h00:8'h1F]}) begin
        case(val)
            8'h0A: return "\\n";
            default: return $sformatf("\\x%h", val);
        endcase
    end else begin
        return $sformatf("%c", val);
    end
endfunction
*/

endmodule