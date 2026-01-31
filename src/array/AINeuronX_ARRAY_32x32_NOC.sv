module AINeuronX_ARRAY_32x32_NOC #(
    parameter DW = 16,
    parameter X = 32,
    parameter Y = 32
)(
    input  logic clk,
    input  logic rst_n,

    input  logic array_enable,

    input  logic         in_valid,
    input  logic [DW-1:0] in_data,
    output logic         in_ready,

    output logic         out_valid,
    output logic [DW-1:0] out_data,
    input  logic         out_ready
);

    // -----------------------------
    // Señales NoC
    // -----------------------------
    logic n_valid [X-1:0][Y-1:0];
    logic s_valid [X-1:0][Y-1:0];
    logic e_valid [X-1:0][Y-1:0];
    logic w_valid [X-1:0][Y-1:0];

    logic [DW-1:0] n_data [X-1:0][Y-1:0];
    logic [DW-1:0] s_data [X-1:0][Y-1:0];
    logic [DW-1:0] e_data [X-1:0][Y-1:0];
    logic [DW-1:0] w_data [X-1:0][Y-1:0];

    logic n_ready [X-1:0][Y-1:0];
    logic s_ready [X-1:0][Y-1:0];
    logic e_ready [X-1:0][Y-1:0];
    logic w_ready [X-1:0][Y-1:0];

    logic tile_out_valid [X-1:0][Y-1:0];
    logic [DW-1:0] tile_out_data [X-1:0][Y-1:0];

    genvar ix, iy;

    generate
        for (ix = 0; ix < X; ix++) begin : GEN_X
            for (iy = 0; iy < Y; iy++) begin : GEN_Y

                AINeuronX_TILE_XY #(
                    .DW(DW),
                    .X_ID(ix),
                    .Y_ID(iy)
                ) tile (
                    .clk(clk),
                    .rst_n(rst_n),

                    // Norte
                    .n_valid(iy > 0     ? s_valid[ix][iy-1] : in_valid),
                    .n_data (iy > 0     ? s_data [ix][iy-1] : in_data ),
                    .n_ready(n_ready[ix][iy]),

                    // Sur
                    .s_valid(iy < Y-1   ? n_valid[ix][iy+1] : 1'b0),
                    .s_data (iy < Y-1   ? n_data [ix][iy+1] : '0),
                    .s_ready(s_ready[ix][iy]),

                    // Este
                    .e_valid(ix < X-1   ? w_valid[ix+1][iy] : 1'b0),
                    .e_data (ix < X-1   ? w_data [ix+1][iy] : '0),
                    .e_ready(e_ready[ix][iy]),

                    // Oeste
                    .w_valid(ix > 0     ? e_valid[ix-1][iy] : 1'b0),
                    .w_data (ix > 0     ? e_data [ix-1][iy] : '0),
                    .w_ready(w_ready[ix][iy]),

                    // Salida local
                    .out_valid(tile_out_valid[ix][iy]),
                    .out_data (tile_out_data [ix][iy])
                );

            end
        end
    endgenerate

    // -----------------------------
    // Drenaje simple (provisional)
    // -----------------------------
    assign out_valid = tile_out_valid[X-1][Y-1];
    assign out_data  = tile_out_data [X-1][Y-1];
    assign in_ready  = array_enable & out_ready;

endmodule
