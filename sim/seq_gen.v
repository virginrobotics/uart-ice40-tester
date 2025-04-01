module seq_gen #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 8
) (
    input   wire    clk,
    input   wire    rst_n,

    // seq control
    input   wire    en,

    // uart_tx ports
    input   wire    tx_done,
    input   wire    tx_busy,
    output  wire [DATA_WIDTH-1:0]   tx_data,
    output  wire    tx_start,
    
    //word_rom ports
    input   wire [DATA_WIDTH-1:0]   mem_data,
    output  wire [ADDR_WIDTH-1:0]   mem_addr,
    output  wire    mem_rd,
    
);

    // parameters
    parameter COUNTER_WIDTH = 5;
    parameter NUM_STATES = 5;
    parameter COUNTER_LIMIT = 13;
    parameter LOOP_EN = 1;

    // regs
    reg [COUNTER_WIDTH-1:0] char_count;
    reg [ADDR_WIDTH-1:0] addr_reg;
    
    // state machine defs
    reg [NUM_STATES-1:0]    state;
    reg [NUM_STATES-1:0]    next_state;

    parameter IDLE = 5'd0;
    parameter FETCH = 5'd1;
    parameter SEND = 5'd2;
    parameter WAIT = 5'd3;
    parameter INCR_ADDR = 5'd4;


    always @(posedge clk ) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end


    always @(*) begin
        
        next_state = IDLE;

        case (state)
            IDLE: begin
                if (!tx_busy & en) begin
                    next_state = FETCH;
                end else begin
                    next_state = IDLE;
                end
            end 

            FETCH: begin
                next_state = SEND;
            end

            SEND: begin
                next_state = WAIT;
            end

            WAIT: begin
                if (tx_done) begin
                    if (LOOP_EN) begin
                        next_state = INCR_ADDR;
                    end else begin
                        next_state = IDLE;
                    end
                end else begin
                    next_state = WAIT;
                end
            end

            INCR_ADDR: begin
                next_state = IDLE;
            end
            default: 
        endcase
        
    end


    // char address increment
    always @(posedge clk ) begin
        if (!rst_n) begin
            char_count <= 0;
            addr_reg <= 0;
        end else if (state == INCR_ADDR) begin
            if (char_count >= COUNTER_LIMIT) begin
                char_count <= 0;
                addr_reg <= 0;
            end else begin
                char_count <= char_count + 1;
                addr_reg <= addr_reg + 1;
            end
        end else begin
            char_count <= char_count;
            addr_reg <= addr_reg;
        end
        
    end

    assign mem_addr = addr_reg;

    // rom control : fetch word at addr
    always @(posedge clk ) begin
        if (!rst_n) begin
            mem_rd <= 0;
        end else if (state == FETCH) begin
            mem_rd <= 1'b1;
        end else begin
            mem_rd <= 1'b0;
        end
        
    end


    // send char to UART
    always @(posedge clk ) begin
        if (!rst_n) begin
            tx_data <= 1'b0;
            tx_start <= 1'b0;
        end else if (state == SEND) begin
            tx_data <= mem_data;
            tx_start <= 1'b1;
        end else begin
            tx_data <= 1'b0;
            tx_start <= 1'b0;
        end
        
    end




endmodule