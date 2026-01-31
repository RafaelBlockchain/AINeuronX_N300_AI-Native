`timescale 1ns/1ps

module systolic_array #(
    parameter int DATA_WIDTH = 16,
    parameter int ACC_WIDTH  = 32,
    parameter int ROWS = 4,
    parameter int COLS = 4
)(
    input  logic clk,
    input  logic rst_n,

    // Control
    input  logic valid_in,
    input  logic clear_acc,

    // Boundary inputs
    input  logic signed [DATA_WIDTH-1:0] a_in [ROWS-1:0],
    input  logic signed [DATA_WIDTH-1:0] b_in [COLS-1:0],

    // Accumulator outputs
    output logic signed [ACC_WIDTH-1:0] acc_out [ROWS-1:0][COLS-1:0],
    output logic valid_out
);

    logic signed [DATA_WIDTH-1:0] a_wire [ROWS-1:0][COLS:0];
    logic signed [DATA_WIDTH-1:0] b_wire [ROWS:0][COLS-1:0];
    logic valid_wire [ROWS-1:0][COLS-1:0];

    genvar r, c;

    // Inject boundary signals
    generate
        for (r = 0; r < ROWS; r++) begin
            assign a_wire[r][0] = a_in[r];
        end
        for (c = 0; c < COLS; c++) begin
            assign b_wire[0][c] = b_in[c];
        end
    endgenerate

    // PE mesh
    generate
        for (r = 0; r < ROWS; r++) begin : ROW_GEN
            for (c = 0; c < COLS; c++) begin : COL_GEN
                systolic_pe #(
                    .DATA_WIDTH(DATA_WIDTH),
                    .ACC_WIDTH (ACC_WIDTH)
                ) pe (
                    .clk       (clk),
                    .rst_n     (rst_n),
                    .valid_in  (valid_in),
                    .clear_acc (clear_acc),
                    .a_in      (a_wire[r][c]),
                    .b_in      (b_wire[r][c]),
                    .a_out     (a_wire[r][c+1]),
                    .b_out     (b_wire[r+1][c]),
                    .acc_out   (acc_out[r][c]),
                    .valid_out (valid_wire[r][c])
                );
            end
        end
    endgenerate

    assign valid_out = valid_wire[ROWS-1][COLS-1];

endmodule
