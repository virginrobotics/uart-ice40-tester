module tb_top (
    
);
    wire pulse;
    reg clk = 0,trigger;

    always begin
        #5 clk = ~clk;
    end

    top u1 (
        .hwclk(clk),
        .pb(1'b0),
        .ftdi_tx(pulse)
    );

    initial begin
        clk = 0;

        #250 
        $finish;
    end

    initial begin
        // Other initializations
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_top);  
        
    end
      
endmodule