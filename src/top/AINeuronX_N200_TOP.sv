module AINeuronX_N200_TOP #(
    parameter DW = 16
)(
    input  logic clk_main,
    input  logic rst_n,

    input  logic global_enable,

    input  logic         in_valid,
    input  logic [DW-1:0] in_data,
    output logic         in_ready,

    output logic         out_valid,
    output logic [DW-1:0] out_data,
    input  logic         out_ready
);

    // -----------------------------
    // ARRAY 32x32
    // -----------------------------
    AINeuronX_ARRAY_32x32_NOC #(
        .DW(DW),
        .X(32),
        .Y(32)
    ) u_array (
        .clk         (clk_main),
        .rst_n       (rst_n),
        .array_enable(global_enable),

        .in_valid    (in_valid),
        .in_data     (in_data),
        .in_ready    (in_ready),

        .out_valid   (out_valid),
        .out_data    (out_data),
        .out_ready   (out_ready)
    );

endmodule
