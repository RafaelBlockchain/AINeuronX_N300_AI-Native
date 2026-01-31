`timescale 1ns/1ps

module mesh_noc #(
    parameter int N_X    = 8,
    parameter int N_Y    = 8,
    parameter int FLIT_W = 64
)(
    input  logic clk,
    input  logic rst_n
);

    // -------------------------------------------------
    // Parámetros derivados
    // -------------------------------------------------
    localparam int N_TILES = N_X * N_Y;

    // -------------------------------------------------
    // Señales NoC
    // Puertos: 0=LOCAL, 1=N, 2=E, 3=S, 4=W
    // -------------------------------------------------
    logic [FLIT_W-1:0] in_flit   [0:N_TILES-1][0:4];
    logic              in_valid  [0:N_TILES-1][0:4];
    logic              in_ready  [0:N_TILES-1][0:4];

    logic [FLIT_W-1:0] out_flit  [0:N_TILES-1][0:4];
    logic              out_valid [0:N_TILES-1][0:4];
    logic              out_ready [0:N_TILES-1][0:4];

    // -------------------------------------------------
    // Routers
    // -------------------------------------------------
    genvar gx, gy;
    generate
        for (gy = 0; gy < N_Y; gy = gy + 1) begin : GEN_Y
            for (gx = 0; gx < N_X; gx = gx + 1) begin : GEN_X
                localparam int ID = gy*N_X + gx;

                tile_router_v2 #(
                    .FLIT_W(FLIT_W)
                ) router_i (
                    .clk       (clk),
                    .rst_n     (rst_n),

                    .in_flit   (in_flit  [ID]),
                    .in_valid  (in_valid [ID]),
                    .in_ready  (in_ready [ID]),

                    .out_flit  (out_flit [ID]),
                    .out_valid (out_valid[ID]),
                    .out_ready (out_ready[ID])
                );
            end
        end
    endgenerate

    // -------------------------------------------------
    // Inicialización LOCAL (puerto 0)
    // -------------------------------------------------
    genvar i;
    generate
        for (i = 0; i < N_TILES; i = i + 1) begin : CLEAR_LOCAL
            assign in_flit [i][0]  = '0;
            assign in_valid[i][0]  = 1'b0;
            assign out_ready[i][0] = 1'b1;
        end
    endgenerate

    // -------------------------------------------------
    // Interconexión Mesh XY
    // -------------------------------------------------
    genvar x, y;
    generate
        for (y = 0; y < N_Y; y = y + 1) begin : LINK_Y
            for (x = 0; x < N_X; x = x + 1) begin : LINK_X
                localparam int ID = y*N_X + x;

                // NORTH
                if (y > 0) begin : LINK_N
                    localparam int NID = (y-1)*N_X + x;
                    assign in_flit [ID][1]   = out_flit [NID][3];
                    assign in_valid[ID][1]   = out_valid[NID][3];
                    assign out_ready[NID][3] = in_ready [ID][1];
                end else begin
                    assign in_flit [ID][1]   = '0;
                    assign in_valid[ID][1]   = 1'b0;
                end

                // SOUTH
                if (y < N_Y-1) begin : LINK_S
                    localparam int SID = (y+1)*N_X + x;
                    assign in_flit [ID][3]   = out_flit [SID][1];
                    assign in_valid[ID][3]   = out_valid[SID][1];
                    assign out_ready[SID][1] = in_ready [ID][3];
                end else begin
                    assign in_flit [ID][3]   = '0;
                    assign in_valid[ID][3]   = 1'b0;
                end

                // WEST
                if (x > 0) begin : LINK_W
                    localparam int WID = y*N_X + (x-1);
                    assign in_flit [ID][4]   = out_flit [WID][2];
                    assign in_valid[ID][4]   = out_valid[WID][2];
                    assign out_ready[WID][2] = in_ready [ID][4];
                end else begin
                    assign in_flit [ID][4]   = '0;
                    assign in_valid[ID][4]   = 1'b0;
                end

                // EAST
                if (x < N_X-1) begin : LINK_E
                    localparam int EID = y*N_X + (x+1);
                    assign in_flit [ID][2]   = out_flit [EID][4];
                    assign in_valid[ID][2]   = out_valid[EID][4];
                    assign out_ready[EID][4] = in_ready [ID][2];
                end else begin
                    assign in_flit [ID][2]   = '0;
                    assign in_valid[ID][2]   = 1'b0;
                end
            end
        end
    endgenerate

endmodule
