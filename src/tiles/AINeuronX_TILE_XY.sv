module AINeuronX_TILE_XY #(
    parameter DW = 16,
    parameter X_ID = 0,
    parameter Y_ID = 0
)(
    input  logic clk,
    input  logic rst_n,

    input  logic          n_valid, s_valid, e_valid, w_valid,
    input  logic [DW-1:0] n_data,  s_data,  e_data,  w_data,
    output logic          n_ready, s_ready, e_ready, w_ready,

    output logic          out_valid,
    output logic [DW-1:0] out_data
);

    logic core_valid;
    logic core_ready;
    logic [DW-1:0] core_data;

    // CORE placeholder (inyección sintética)
    assign core_valid = 1'b1;
    assign core_data  = {X_ID[3:0], Y_ID[3:0], 8'hAA};

    // ROUTER XY
    AINeuronX_NOC_ROUTER_XY #(
        .DW(DW),
        .X_ID(X_ID),
        .Y_ID(Y_ID)
    ) router (
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

    // =========================
    // TELEMETRÍA HW POR TILE
    // =========================
    AINeuronX_TILE_METRICS metrics (
        .clk(clk),
        .rst_n(rst_n),
        .mac_fire(core_valid & core_ready), // MAC realmente aceptado
        .noc_send(out_valid),
        .stall(core_valid & ~core_ready),
        .mac_ops(),
        .noc_packets(),
        .stall_cycles()
    );

endmodule
