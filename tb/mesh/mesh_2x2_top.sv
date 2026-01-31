module mesh_2x2_top #(
    parameter int FLIT_W = 128
)(
    input logic clk,
    input logic rst_n,

    input  logic              inj_valid,
    output logic              inj_ready,
    input  logic [FLIT_W-1:0] inj_flit
);

    logic [FLIT_W-1:0] flit_00, flit_01, flit_10, flit_11;
    logic v_00, v_01, v_10, v_11;
    logic r_00, r_01, r_10, r_11;

    noc_xy_router #(.X_ID(0), .Y_ID(0)) R00 (
        .clk, .rst_n,
        .in_valid(inj_valid), .in_ready(inj_ready), .in_flit(inj_flit),
        .e_valid(v_10), .e_ready(r_10), .e_flit(flit_10),
        .n_valid(v_01), .n_ready(r_01), .n_flit(flit_01),
        .s_valid(), .w_valid(),
        .s_ready(1'b1), .w_ready(1'b1)
    );

    noc_xy_router #(.X_ID(1), .Y_ID(0)) R10 (
        .clk, .rst_n,
        .in_valid(v_10), .in_ready(r_10), .in_flit(flit_10),
        .w_valid(), .e_valid(),
        .n_valid(v_11), .n_ready(r_11), .n_flit(flit_11),
        .s_valid(),
        .w_ready(1'b1), .e_ready(1'b1), .s_ready(1'b1)
    );

    noc_xy_router #(.X_ID(0), .Y_ID(1)) R01 (
        .clk, .rst_n,
        .in_valid(v_01), .in_ready(r_01), .in_flit(flit_01),
        .e_valid(v_11), .e_ready(r_11), .e_flit(flit_11),
        .s_valid(), .n_valid(),
        .s_ready(1'b1), .n_ready(1'b1)
    );

    noc_xy_router #(.X_ID(1), .Y_ID(1)) R11 (
        .clk, .rst_n,
        .in_valid(v_11), .in_ready(r_11), .in_flit(flit_11),
        .w_valid(), .e_valid(), .n_valid(), .s_valid(),
        .w_ready(1'b1), .e_ready(1'b1),
        .n_ready(1'b1), .s_ready(1'b1)
    );

endmodule
