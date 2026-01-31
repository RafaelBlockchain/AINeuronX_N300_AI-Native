`timescale 1ns/1ps

module AINeuronX_ARRAY_2x2 #(
    parameter DW = 16
)(
    input  logic clk,
    input  logic rst_n,
    input  logic in_valid,
    input  logic [DW-1:0] a [0:3],
    input  logic [DW-1:0] b [0:3],
    output logic out_valid,
    output logic [DW-1:0] result [0:3]
);

    // Señales internas de cada core
    logic [3:0] core_out_valid;
    logic [DW-1:0] core_output [0:3];

    genvar i;
    generate
        for (i = 0; i < 4; i++) begin : CORE_GEN
            AINeuronX_N200_CORE #(
                .DATA_WIDTH(DW),
                .VECTOR_LANES(1)
            ) core_inst (
                .clk       (clk),
                .rst_n     (rst_n),
                .valid_in  (in_valid),
                .prefetch_enable(1'b1),
                .input_a   (a[i]),
                .input_b   (b[i]),
                .ready_out (core_out_valid[i]),
                .output_data(core_output[i])
            );

            assign result[i] = core_output[i];
        end
    endgenerate

    // Salida válida solo si todos los cores están listos
    assign out_valid = &core_out_valid;

endmodule
