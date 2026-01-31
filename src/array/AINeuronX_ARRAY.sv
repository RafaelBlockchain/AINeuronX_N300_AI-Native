module AINeuronX_ARRAY #(parameter NX=4, NY=4, LANES=16, DW=16)(
    input logic clk, rst,
    input logic global_valid,
    output logic global_ready,
    input logic [DW-1:0] global_a [LANES],
    input logic [DW-1:0] global_b [LANES],
    output logic global_out_valid,
    input logic global_out_ready,
    output logic [DW*2-1:0] global_result [LANES]
);
    AINeuronX_N200_TILE tile (
        .clk(clk), .rst(rst),
        .tile_valid(global_valid),
        .tile_ready(global_ready),
        .tile_a(global_a),
        .tile_b(global_b),
        .tile_out_valid(global_out_valid),
        .tile_out_ready(global_out_ready),
        .tile_result(global_result)
    );
endmodule
