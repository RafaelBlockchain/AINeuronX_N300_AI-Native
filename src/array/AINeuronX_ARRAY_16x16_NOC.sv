`timescale 1ns/1ps
module AINeuronX_ARRAY_16x16_NOC #(
    parameter DW = 16,
    parameter LANE_SIZE = 1
)(
    input  logic clk,
    input  logic rst_n,
    input  logic in_valid,
    input  logic [DW-1:0] a [0:255],
    input  logic [DW-1:0] b [0:255],
    output logic out_valid,
    output logic [DW-1:0] result [0:255]
);

    logic [255:0] core_valid;
    logic [DW-1:0] core_out [0:255];

    genvar i;
    generate
        for(i = 0; i < 256; i=i+1) begin: CORE
            AINeuronX_N200_CORE_MAC #(
                .DATA_WIDTH(DW),
                .VECTOR_LANES(LANE_SIZE)
            ) core_inst (
                .clk(clk),
                .rst_n(rst_n),
                .valid_in(in_valid),
                .prefetch_enable(1'b1),
                .input_a(a[i*LANE_SIZE +: LANE_SIZE]),
                .input_b(b[i*LANE_SIZE +: LANE_SIZE]),
                .ready_out(core_valid[i]),
                .output_data(core_out[i*LANE_SIZE +: LANE_SIZE])
            );
            assign result[i*LANE_SIZE +: LANE_SIZE] = core_out[i*LANE_SIZE +: LANE_SIZE];
        end
    endgenerate

    // NoC simulada: salida lista cuando todos los cores completan
    assign out_valid = &core_valid;

endmodule
