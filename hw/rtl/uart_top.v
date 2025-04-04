// Simulation commands
// iverilog -o uart_tb uart_top.v uart_tb.v
// vvp uart_tb
// gtkwave uart_tb.vcd &





module uart_top #(
    parameter DATA_WIDTH = 8
) (
    input   wire    clk,
    input   wire    rst_n,
    
    input   wire [DATA_WIDTH-1:0]    data_in,
    input   wire    start,

    output  wire    uart_tx,
    output  wire    done,
    output  wire    uart_busy 
);

    // parameters
    parameter COUNTER_WIDTH = 5;
    parameter NUM_STATES = 5;
    parameter COUNTER_LIMIT = 7;


    // register to store data frame to be sent
    reg [DATA_WIDTH-1:0]    hold_reg = 0;
    reg [COUNTER_WIDTH-1:0]   shift_counter = 0;

    // status
    reg done_reg;

    // state machine regs
    reg [NUM_STATES-1:0]   state;
    reg [NUM_STATES-1:0]   next_state;

    parameter IDLE = 5'd0;
    parameter START = 5'd1;
    parameter SEND = 5'd2;
    parameter STOP = 5'd3;

    always @(posedge clk ) begin

        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
        
    end

    // next state logic
    always @(*) begin

        next_state = IDLE;

        case (state)
            IDLE: begin
                if (start) begin
                    next_state = START;
                end else begin
                    next_state = IDLE;                    
                end
            end 

            START: begin
                next_state = SEND;
            end

            SEND: begin
                if (shift_counter >= COUNTER_LIMIT) begin
                    next_state = STOP;
                end else begin
                    next_state = SEND;
                end
            end

            STOP: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
        
    end
    // end of next state logic


    // hold register
    always @(posedge clk ) begin
        if (!rst_n) begin
            hold_reg <= 0;
        end else if (state == START) begin
            hold_reg <= data_in;
        end
    end

    // counter
    always @(posedge clk ) begin
        if (!rst_n) begin
            shift_counter <= 0;
        end else if (state == SEND) begin
            shift_counter <= shift_counter + 1;            
        end else begin
            shift_counter <= 0;
        end
    end

    //done signal
    always @(posedge clk ) begin
        if (!rst_n) begin
            done_reg <= 0;
        end else if (state == STOP) begin
            done_reg <= 1;            
        end else begin
            done_reg <= 0;
        end
    end
    
    // outputs
    assign uart_tx = (state == START) ? 1'b0 : // start bit
                     (state == SEND && shift_counter < DATA_WIDTH) ? hold_reg[shift_counter] : // data if counter within valid range
                     1'b1; // stop bit
    assign done = done_reg;
    assign uart_busy = (state == IDLE) ? 1'b0 : 1'b1;
    
endmodule