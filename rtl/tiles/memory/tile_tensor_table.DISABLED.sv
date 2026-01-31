module tile_tensor_table #(
    parameter TENSOR_ID_W = 8,
    parameter ADDR_W      = 32,
    parameter DEPTH       = 16
)(
    input  logic clk,
    input  logic rst,

    // write
    input  logic we,
    input  logic [TENSOR_ID_W-1:0] wr_id,
    input  logic [ADDR_W-1:0]      wr_addr,

    // read src0
    input  logic [TENSOR_ID_W-1:0] rd0_id,
    output logic [ADDR_W-1:0]      rd0_addr,

    // read src1
    input  logic [TENSOR_ID_W-1:0] rd1_id,
    output logic [ADDR_W-1:0]      rd1_addr,

    // read dst
    input  logic [TENSOR_ID_W-1:0] rd_dst_id,
    output logic [ADDR_W-1:0]      rd_dst_addr
);

    logic [ADDR_W-1:0] table [DEPTH];

    always_ff @(posedge clk) begin
        if (we)
            table[wr_id] <= wr_addr;
    end

    assign rd0_addr     = table[rd0_id];
    assign rd1_addr     = table[rd1_id];
    assign rd_dst_addr  = table[rd_dst_id];

endmodule

