module cache_l1 #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 64,
    parameter LINES = 64
)(
    input  logic                  clk,
    input  logic                  valid,
    input  logic                  we,
    input  logic [ADDR_WIDTH-1:0] addr,
    input  logic [DATA_WIDTH-1:0] wdata,
    output logic [DATA_WIDTH-1:0] rdata,
    output logic                  hit
);

    localparam INDEX_WIDTH = $clog2(LINES);

    logic [DATA_WIDTH-1:0] data [0:LINES-1];
    logic [ADDR_WIDTH-INDEX_WIDTH-1:0] tag [0:LINES-1];
    logic valid_line [0:LINES-1];

    wire [INDEX_WIDTH-1:0] index = addr[INDEX_WIDTH-1:0];
    wire [ADDR_WIDTH-INDEX_WIDTH-1:0] addr_tag = addr[ADDR_WIDTH-1:INDEX_WIDTH];

    always_ff @(posedge clk) begin
        if (valid) begin
            if (we) begin
                data[index] <= wdata;
                tag[index]  <= addr_tag;
                valid_line[index] <= 1'b1;
            end
            rdata <= data[index];
            hit <= valid_line[index] && (tag[index] == addr_tag);
        end else begin
            hit <= 1'b0;
        end
    end

endmodule
