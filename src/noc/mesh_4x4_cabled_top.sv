module mesh_4x4_cabled_top #(
    parameter int FLIT_W = 128,
    parameter int NX = 4,
    parameter int NY = 4
)(
    input logic clk,
    input logic rst_n
);

    // Local injection
    logic              loc_valid [NX][NY];
    logic              loc_ready [NX][NY];
    logic [FLIT_W-1:0] loc_flit  [NX][NY];

    // Inter-router links
    logic              e_valid [NX][NY], w_valid [NX][NY];
    logic              n_valid [NX][NY], s_valid [NX][NY];
    logic              e_ready [NX][NY], w_ready [NX][NY];
    logic              n_ready [NX][NY], s_ready [NX][NY];
    logic [FLIT_W-1:0] e_flit  [NX][NY], w_flit  [NX][NY];
    logic [FLIT_W-1:0] n_flit  [NX][NY], s_flit  [NX][NY];

    genvar x, y;
    generate
        for (x = 0; x < NX; x++) begin : GX
            for (y = 0; y < NY; y++) begin : GY

                // Injector por tile
                tile_injector #(
                    .X_ID(x), .Y_ID(y)
                ) inj (
                    .clk(clk),
                    .rst_n(rst_n),
                    .out_valid(loc_valid[x][y]),
                    .out_ready(loc_ready[x][y]),
                    .out_flit (loc_flit[x][y])
                );

                // Router
                noc_xy_router_vc #(
                    .X_ID(x), .Y_ID(y)
                ) rtr (
                    .clk(clk),
                    .rst_n(rst_n),

                    .in_valid(loc_valid[x][y]),
                    .in_ready(loc_ready[x][y]),
                    .in_flit (loc_flit[x][y]),

                    .e_valid(e_valid[x][y]),
                    .e_ready(e_ready[x][y]),
                    .e_flit (e_flit [x][y]),

                    .w_valid(w_valid[x][y]),
                    .w_ready(w_ready[x][y]),
                    .w_flit (w_flit [x][y]),

                    .n_valid(n_valid[x][y]),
                    .n_ready(n_ready[x][y]),
                    .n_flit (n_flit [x][y]),

                    .s_valid(s_valid[x][y]),
                    .s_ready(s_ready[x][y]),
                    .s_flit (s_flit [x][y])
                );

                // East/West wiring
                if (x < NX-1) begin
                    assign w_ready[x+1][y] = e_ready[x][y];
                    assign w_flit [x+1][y] = e_flit [x][y];
                    assign w_valid[x+1][y] = e_valid[x][y];
                end

                if (x > 0) begin
                    assign e_ready[x-1][y] = w_ready[x][y];
                    assign e_flit [x-1][y] = w_flit [x][y];
                    assign e_valid[x-1][y] = w_valid[x][y];
                end

                // North/South wiring
                if (y < NY-1) begin
                    assign s_ready[x][y+1] = n_ready[x][y];
                    assign s_flit [x][y+1] = n_flit [x][y];
                    assign s_valid[x][y+1] = n_valid[x][y];
                end

                if (y > 0) begin
                    assign n_ready[x][y-1] = s_ready[x][y];
                    assign n_flit [x][y-1] = s_flit [x][y];
                    assign n_valid[x][y-1] = s_valid[x][y];
                end

            end
        end
    endgenerate

endmodule

