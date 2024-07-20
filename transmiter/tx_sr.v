module tx_sr #(
    parameter DATA_W = 8,
    parameter FRAME_W = 10
) (
    input    wire                   clk,
    input    wire                   enable,
    input    wire   [DATA_W-1:0]    i_data,
    output   wire                   o_frame,
    output   wire                   o_txsr_empty

);

reg [FRAME_W-1:0] tx_shift_reg = 0;
reg [4:0] lvl_pointer = 0;
reg load_data = 0;

// Start of FSM
localparam [3:0] IDLE = 4'h0;
localparam [3:0]LOAD = 4'h1;
localparam [3:0]TXSHIFT = 4'h2;
reg [3:0] state = 0;
reg [3:0] next_state = 0;
wire transmit_stage;

always @(posedge clk ) begin
    state <= next_state;
end

always @(*) begin

    case (state)
        IDLE: begin
            if (enable) begin
                next_state = LOAD;
                load_data = 1;
            end else begin
                next_state = IDLE;
            end
        end 
        LOAD: begin
            next_state = TXSHIFT;
        end
        TXSHIFT: begin
            if (lvl_pointer > 5'd1) begin
                next_state = TXSHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;

    endcase
    
end

assign transmit_stage = (state == TXSHIFT) ? 1'b1 : 1'b0;



// End of FSM

always @(posedge clk ) begin
    if (load_data) begin
        tx_shift_reg <= {1'b1,i_data,1'b0}; //stop bit --- D7 to D0 --- start bit. Right shift , LSB first.
        lvl_pointer <= 5'd9;
        load_data <= 0;  
    end else if (transmit_stage) begin
        tx_shift_reg <= tx_shift_reg >> 1;
        lvl_pointer <= lvl_pointer - 1;
    end
end

assign o_frame = (transmit_stage) ? tx_shift_reg[0] : 1;
assign o_txsr_empty = (lvl_pointer == 0) ? 1 : 0;

endmodule