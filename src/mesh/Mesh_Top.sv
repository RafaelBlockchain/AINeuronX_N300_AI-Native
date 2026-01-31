`timescale 1ns/1ps
import noc_types::*;

module Mesh_Top #(
    parameter int X_SIZE = 8,
    parameter int Y_SIZE = 8
)(
    input logic clk,
    input logic rst_n
);

    // =================================
    // Inter-tile links
    // =================================
    flit_t link_n_flit [X_SIZE][Y_SIZE];
    flit_t link_s_flit [X_SIZE][Y_SIZE];
    flit_t link_e_flit [X_SIZE][Y_SIZE];
    flit_t link_w_flit [X_SIZE][Y_SIZE];

    logic link_n_valid [X_SIZE][Y_SIZE];
    logic link_s_valid [X_SIZE][Y_SIZE];
    logic link_e_valid [X_SIZE][Y_SIZE];
    logic link_w_valid [X_SIZE][Y_SIZE];

    logic link_n_ready [X_SIZE][Y_SIZE];
    logic link_s_ready [X_SIZE][Y_SIZE];
    logic link_e_ready [X_SIZE][Y_SIZE];
    logic link_w_ready [X_SIZE][Y_SIZE];

    // =================================
    // Tile instantiation
    // =================================
    genvar x, y;
    generate
        for (x = 0; x < X_SIZE; x++) begin : GEN_X
            for (y = 0; y < Y_SIZE; y++) begin : GEN_Y

                Tile_Top #(
                    .X_ID(x),
                    .Y_ID(y)
                ) tile (
                    .clk(clk),
                    .rst_n(rst_n),
                    .tile_active(1'b1),

                    // NORTH
                    .n_in_flit  ( (y > 0)        ? link_s_flit[x][y-1]  : '0 ),
                    .n_in_valid ( (y > 0)        ? link_s_valid[x][y-1] : 1'b0 ),
                    .n_in_ready ( link_n_ready[x][y] ),

                    // SOUTH
                    .s_in_flit  ( (y < Y_SIZE-1) ? link_n_flit[x][y+1]  : '0 ),
                    .s_in_valid ( (y < Y_SIZE-1) ? link_n_valid[x][y+1] : 1'b0 ),
                    .s_in_ready ( link_s_ready[x][y] ),

                    // EAST
                    .e_in_flit  ( (x < X_SIZE-1) ? link_w_flit[x+1][y]  : '0 ),
                    .e_in_valid ( (x < X_SIZE-1) ? link_w_valid[x+1][y] : 1'b0 ),
                    .e_in_ready ( link_e_ready[x][y] ),

                    // WEST
                    .w_in_flit  ( (x > 0)        ? link_e_flit[x-1][y]  : '0 ),
                    .w_in_valid ( (x > 0)        ? link_e_valid[x-1][y] : 1'b0 ),
                    .w_in_ready ( link_w_ready[x][y] ),

                    // OUT
                    .n_out_flit ( link_n_flit[x][y] ),
                    .n_out_valid( link_n_valid[x][y] ),
                    .n_out_ready( (y > 0) ? link_n_ready[x][y-1] : 1'b1 ),

                    .s_out_flit ( link_s_flit[x][y] ),
                    .s_out_valid( link_s_valid[x][y] ),
                    .s_out_ready( (y < Y_SIZE-1) ? link_s_ready[x][y+1] : 1'b1 ),

                    .e_out_flit ( link_e_flit[x][y] ),
                    .e_out_valid( link_e_valid[x][y] ),
                    .e_out_ready( (x < X_SIZE-1) ? link_e_ready[x+1][y] : 1'b1 ),

                    .w_out_flit ( link_w_flit[x][y] ),
                    .w_out_valid( link_w_valid[x][y] ),
                    .w_out_ready( (x > 0) ? link_w_ready[x-1][y] : 1'b1 )
                );

            end
        end
    endgenerate

endmodule
