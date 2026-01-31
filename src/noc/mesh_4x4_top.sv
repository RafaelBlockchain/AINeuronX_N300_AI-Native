module mesh_4x4_top #(
    parameter int FLIT_W = 128,
    parameter int NX = 4,
    parameter int NY = 4
)(
    input logic clk,
    input logic rst_n
);

    // Inter-router signals
    logic [FLIT_W-1:0] flit   [NX][NY];
    logic              valid  [NX][NY];
    logic              ready  [NX][NY];

    genvar x, y;
    generate
        for (x = 0; x < NX; x++) begin : GX
            for (y = 0; y < NY; y++) begin : GY
                noc_xy_router_vc #(
                    .X_ID(x),
                    .Y_ID(y)
                ) router (
                    .clk(clk),
                    .rst_n(rst_n),

                    .in_valid(valid[x][y]),
                    .in_ready(ready[x][y]),
                    .in_flit (flit[x][y]),

                    .e_valid(), .w_valid(), .n_valid(), .s_valid(),
                    .e_ready(1'b1), .w_ready(1'b1),
                    .n_ready(1'b1), .s_ready(1'b1),
                    .e_flit(), .w_flit(), .n_flit(), .s_flit()
                );
            end
        end
    endgenerate

endmodule

