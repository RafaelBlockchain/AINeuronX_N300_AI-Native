module mesh_top #(
    parameter int FLIT_W = 128,
    parameter int NX = 8,
    parameter int NY = 8
)(
    input logic clk,
    input logic rst_n
);

    // Inter-router links
    logic [FLIT_W-1:0] flit_e [NX][NY];
    logic [FLIT_W-1:0] flit_w [NX][NY];
    logic [FLIT_W-1:0] flit_n [NX][NY];
    logic [FLIT_W-1:0] flit_s [NX][NY];

    logic valid_e [NX][NY], ready_e [NX][NY];
    logic valid_w [NX][NY], ready_w [NX][NY];
    logic valid_n [NX][NY], ready_n [NX][NY];
    logic valid_s [NX][NY], ready_s [NX][NY];

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

                    // West
                    .w_valid(x > 0     ? valid_e[x-1][y] : 1'b0),
                    .w_ready(ready_w[x][y]),
                    .w_flit (x > 0     ? flit_e [x-1][y] : '0),

                    // East
                    .e_valid(x < NX-1  ? valid_w[x+1][y] : 1'b0),
                    .e_ready(ready_e[x][y]),
                    .e_flit (x < NX-1  ? flit_w [x+1][y] : '0),

                    // South
                    .s_valid(y > 0     ? valid_n[x][y-1] : 1'b0),
                    .s_ready(ready_s[x][y]),
                    .s_flit (y > 0     ? flit_n [x][y-1] : '0),

                    // North
                    .n_valid(y < NY-1  ? valid_s[x][y+1] : 1'b0),
                    .n_ready(ready_n[x][y]),
                    .n_flit (y < NY-1  ? flit_s [x][y+1] : '0)
                );

            end
        end
    endgenerate

endmodule

