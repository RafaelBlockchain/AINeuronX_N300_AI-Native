module AINeuronX_TILE #(
    parameter DW = 16
)(
    input  logic clk,
    input  logic rst_n,

    // NoC ports
    input  logic        n_valid,
    input  logic [DW-1:0] n_data,
    output logic        n_ready,

    input  logic        s_valid,
    input  logic [DW-1:0] s_data,
    output logic        s_ready,

    input  logic        e_valid,
    input  logic [DW-1:0] e_data,
    output logic        e_ready,

    input  logic        w_valid,
    input  logic [DW-1:0] w_data,
    output logic        w_ready,

    output logic        out_valid,
    output logic [DW-1:0] out_data
);

    logic core_valid;
    logic [DW-1:0] core_data;
    logic core_ready;

    // CORE
    AINeuronX_MAC_CORE core (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(core_valid),
        .a(core_data),
        .b(core_data),
        .valid_out(),
        .result(core_data)
    );

    // ROUTER
    AINeuronX_NOC_ROUTER router (
        .clk(clk),
        .rst_n(rst_n),

        .l_valid(core_valid),
        .l_data(core_data),
        .l_ready(core_ready),

        .n_valid(n_valid), .n_data(n_data), .n_ready(n_ready),
        .s_valid(s_valid), .s_data(s_data), .s_ready(s_ready),
        .e_valid(e_valid), .e_data(e_data), .e_ready(e_ready),
        .w_valid(w_valid), .w_data(w_data), .w_ready(w_ready),

        .out_valid(out_valid),
        .out_data(out_data)
    );

endmodule
