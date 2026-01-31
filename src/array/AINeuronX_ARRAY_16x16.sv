`timescale 1ns/1ps

module AINeuronX_ARRAY_16x16 #(
    parameter DW = 16,
    parameter LANE_SIZE = 1   // lanes por core
)(
    input  logic clk,
    input  logic rst_n,
    input  logic in_valid,
    input  logic [DW-1:0] a [0:255],
    input  logic [DW-1:0] b [0:255],
    output logic out_valid,
    output logic [DW-1:0] result [0:255]
);

    // Señales internas de cada core
    logic [255:0] core_out_valid;
    logic [DW-1:0] core_output [0:255];

    genvar i;
    generate
        for (i = 0; i < 256; i++) begin : CORE_GEN
            AINeuronX_N200_CORE #(
                .DATA_WIDTH(DW),
                .VECTOR_LANES(LANE_SIZE)
            ) core_inst (
                .clk       (clk),
                .rst_n     (rst_n),
                .valid_in  (in_valid),
                .prefetch_enable(1'b1),
                .input_a   (a[i*LANE_SIZE +: LANE_SIZE]),
                .input_b   (b[i*LANE_SIZE +: LANE_SIZE]),
                .ready_out (core_out_valid[i]),
                .output_data(core_output[i*LANE_SIZE +: LANE_SIZE])
            );

            assign result[i*LANE_SIZE +: LANE_SIZE] = core_output[i*LANE_SIZE +: LANE_SIZE];
        end
    endgenerate

    // Salida válida solo si todos los cores están listos
    assign out_valid = &core_out_valid;

endmodule
