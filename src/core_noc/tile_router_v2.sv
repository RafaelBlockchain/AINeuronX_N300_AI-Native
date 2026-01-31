`timescale 1ns/1ps

module tile_router_v2 #(
    parameter int FLIT_W = 64,
    parameter int PORTS  = 5,   // 0=L, 1=W, 2=E, 3=S, 4=N
    parameter int X_ID   = 0,
    parameter int Y_ID   = 0
)(
    input  logic clk,
    input  logic rst_n,

    input  logic [FLIT_W-1:0] in_flit  [PORTS],
    input  logic              in_valid [PORTS],
    output logic              in_ready [PORTS],

    output logic [FLIT_W-1:0] out_flit  [PORTS],
    output logic              out_valid [PORTS],
    input  logic              out_ready [PORTS],

    input  logic tile_active
);

    // =========================================================
    // Clock gating simple (Icarus-safe)
    // =========================================================
    logic clk_g;
    assign clk_g = clk & tile_active;

    // =========================================================
    // FIFOs por puerto de entrada
    // =========================================================
    logic [FLIT_W-1:0] fifo_dout [PORTS];
    logic fifo_empty [PORTS];
    logic fifo_full  [PORTS];

    genvar p;
    generate
        for (p = 0; p < PORTS; p = p + 1) begin : FIFO_GEN
            tile_fifo #(
                .FLIT_W (FLIT_W),
                .DEPTH  (4)
            ) fifo_i (
                .clk   (clk_g),
                .rst_n (rst_n),
                .push  (in_valid[p] && in_ready[p]),
                .pop   (out_ready[p] && out_valid[p]),
                .din   (in_flit[p]),
                .dout  (fifo_dout[p]),
                .empty (fifo_empty[p]),
                .full  (fifo_full[p])
            );
        end
    endgenerate

    // =========================================================
    // READY de entrada (explícito, sin concatenaciones)
    // =========================================================
    integer i;
    always_comb begin
        for (i = 0; i < PORTS; i = i + 1) begin
            in_ready[i] = ~fifo_full[i];
        end
    end

    // =========================================================
    // ROUTING XY FIJO (simple y determinista)
    // Bits flit:
    // [63:56] src_x
    // [55:48] src_y
    // [47:40] dst_x
    // [39:32] dst_y
    // =========================================================
    logic [2:0] route_port [PORTS];

    always_comb begin
        for (i = 0; i < PORTS; i = i + 1) begin
            route_port[i] = 3'd0; // default LOCAL

            if (!fifo_empty[i]) begin
                if (fifo_dout[i][47:40] > X_ID)
                    route_port[i] = 3'd2; // EAST
                else if (fifo_dout[i][47:40] < X_ID)
                    route_port[i] = 3'd1; // WEST
                else if (fifo_dout[i][39:32] > Y_ID)
                    route_port[i] = 3'd4; // NORTH
                else if (fifo_dout[i][39:32] < Y_ID)
                    route_port[i] = 3'd3; // SOUTH
                else
                    route_port[i] = 3'd0; // LOCAL
            end
        end
    end

    // =========================================================
    // SALIDAS (1:1 simple, sin crossbar aún)
    // =========================================================
    always_comb begin
        for (i = 0; i < PORTS; i = i + 1) begin
            out_flit[i]  = '0;
            out_valid[i] = 1'b0;
        end

        for (i = 0; i < PORTS; i = i + 1) begin
            if (!fifo_empty[i]) begin
                out_flit[ route_port[i] ]  = fifo_dout[i];
                out_valid[route_port[i]]   = 1'b1;
            end
        end
    end

endmodule
