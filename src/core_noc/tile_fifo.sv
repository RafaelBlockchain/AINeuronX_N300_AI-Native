`timescale 1ns/1ps

module tile_fifo #(
    parameter int FLIT_W = 64,
    parameter int DEPTH  = 4
)(
    input  logic clk,
    input  logic rst_n,
    input  logic push,
    input  logic pop,
    input  logic [FLIT_W-1:0] din,
    output logic [FLIT_W-1:0] dout,
    output logic empty,
    output logic full
);

    logic [FLIT_W-1:0] mem [DEPTH];
    integer rd_ptr, wr_ptr, count;

    assign empty = (count == 0);
    assign full  = (count == DEPTH);
    assign dout  = mem[rd_ptr];

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr <= 0;
            wr_ptr <= 0;
            count  <= 0;
        end else begin
            if (push && !full) begin
                mem[wr_ptr] <= din;
                wr_ptr <= (wr_ptr + 1) % DEPTH;
                count  <= count + 1;
            end
            if (pop && !empty) begin
                rd_ptr <= (rd_ptr + 1) % DEPTH;
                count  <= count - 1;
            end
        end
    end

endmodule
