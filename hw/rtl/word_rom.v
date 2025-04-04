module word_rom #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 8
) (
    input   wire    clk,
    input   wire    rst_n,
    
    input   wire [ADDR_WIDTH-1:0]   addr,
    input   wire    rd_en,

    output  wire [DATA_WIDTH-1:0]   rd_data
);

    localparam DEPTH = 2**ADDR_WIDTH;
    localparam RD_LIMIT = 14; // memory init till this addr

    reg [DATA_WIDTH-1:0] mem [DEPTH-1:0];
    reg [DATA_WIDTH-1:0] data_reg;
    
    
    initial begin
        mem[0]  = 8'h48;  // 'H'
        mem[1]  = 8'h65;  // 'e'
        mem[2]  = 8'h6C;  // 'l'
        mem[3]  = 8'h6C;  // 'l'
        mem[4]  = 8'h6F;  // 'o'
        mem[5]  = 8'h20;  // ' ' (space)
        mem[6]  = 8'h57;  // 'W'
        mem[7]  = 8'h6F;  // 'o'
        mem[8]  = 8'h72;  // 'r'
        mem[9]  = 8'h6C;  // 'l'
        mem[10] = 8'h64;  // 'd'
        mem[11] = 8'h20;  // ' ' (space)
        mem[12] = 8'h21;  // '!'
        mem[13] = 8'h0A;  // '\n' (newline)
    end


    always @(posedge clk ) begin
        if (!rst_n) begin
            data_reg <= 0;
            
        end else if (rd_en && addr < RD_LIMIT) begin
            data_reg <= mem[addr]; 
            
        end else begin
            //data_reg <= 0;
            data_reg <= data_reg;
        end
        
    end

    assign rd_data = data_reg; 
    
endmodule