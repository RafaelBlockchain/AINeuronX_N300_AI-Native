
module cdc_async_fifo #(
    parameter int W = 128,
    parameter int DEPTH = 4
)(
    input  logic wr_clk,
    input  logic rd_clk,
    input  logic rst_n,

    input  logic wr_en,
    input  logic [W-1:0] din,
    output logic full,

    input  logic rd_en,
    output logic [W-1:0] dout,
    output logic empty
);
    logic [W-1:0] mem[DEPTH-1:0];
    logic [$clog2(DEPTH):0] wptr, rptr;

    assign full  = ((wptr + 1) == rptr);
    assign empty = (wptr == rptr);

    always_ff @(posedge wr_clk)
        if (wr_en && !full) begin
            mem[wptr[$clog2(DEPTH)-1:0]] <= din;
            wptr <= wptr + 1;
        end

    always_ff @(posedge rd_clk)
        if (rd_en && !empty) begin
            dout <= mem[rptr[$clog2(DEPTH)-1:0]];
            rptr <= rptr + 1;
        end
endmodule
