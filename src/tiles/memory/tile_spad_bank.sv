`timescale 1ns/1ps

module tile_spad_bank #(
    parameter DATA_WIDTH = 16,
    parameter DEPTH      = 4096  // 8KB / 2 bytes
)(
    input  logic clk,

    input  logic        we,
    input  logic [$clog2(DEPTH)-1:0] addr,
    input  logic [DATA_WIDTH-1:0] wdata,

    output logic [DATA_WIDTH-1:0] rdata
);

    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    always_ff @(posedge clk) begin
        if (we)
            mem[addr] <= wdata;
        rdata <= mem[addr];
    end

endmodule
