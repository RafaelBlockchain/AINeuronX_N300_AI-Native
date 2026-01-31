`timescale 1ns/1ps

module Tile_Core_Compute #(
    parameter int DATA_WIDTH = 16,
    parameter int ACC_WIDTH  = 32,
    parameter int ROWS = 4,
    parameter int COLS = 4,
    parameter int K_DIM = 16,
    parameter int LANES = 4
)(
    input  logic clk,
    input  logic rst_n,

    // Command interface
    input  logic        cmd_valid,
    input  logic [1:0]  cmd_type,     // 01: tensor, 10: vector
    input  logic        cmd_start,

    output logic        busy,
    output logic        done,

    // ===================== Tensor interfaces =====================
    input  logic        tensor_load,
    input  logic        tensor_start,

    input  logic signed [DATA_WIDTH-1:0] tensor_a [ROWS-1:0][K_DIM-1:0],
    input  logic signed [DATA_WIDTH-1:0] tensor_b [K_DIM-1:0][COLS-1:0],

    output logic signed [ACC_WIDTH-1:0]  tensor_out [ROWS-1:0][COLS-1:0],

    // ===================== Vector interfaces =====================
    input  logic        vector_start,
    input  logic [1:0]  vector_op,     // 00 ADD, 01 MUL, 10 MAC

    input  logic signed [DATA_WIDTH-1:0] vector_a   [LANES-1:0],
    input  logic signed [DATA_WIDTH-1:0] vector_b   [LANES-1:0],
    input  logic signed [DATA_WIDTH-1:0] vector_acc [LANES-1:0],

    output logic signed [DATA_WIDTH-1:0] vector_out [LANES-1:0]
);

    // ============================================================
    // Tensor path
    // ============================================================
    logic tensor_valid;
    logic tensor_clear;
    logic tensor_done;

    logic signed [DATA_WIDTH-1:0] a_bus [ROWS-1:0];
    logic signed [DATA_WIDTH-1:0] b_bus [COLS-1:0];

    systolic_ctrl #(
        .ROWS (ROWS),
        .COLS (COLS),
        .K_DIM(K_DIM)
    ) u_tensor_ctrl (
        .clk       (clk),
        .rst_n     (rst_n),
        .start     (tensor_start),
        .busy      (),
        .done      (tensor_done),
        .valid_in  (tensor_valid),
        .clear_acc (tensor_clear)
    );

    systolic_buffer #(
        .DATA_WIDTH(DATA_WIDTH),
        .ROWS      (ROWS),
        .COLS      (COLS),
        .K_DIM     (K_DIM)
    ) u_tensor_buf (
        .clk    (clk),
        .rst_n  (rst_n),
        .load   (tensor_load),
        .shift  (tensor_valid),
        .a_load (tensor_a),
        .b_load (tensor_b),
        .a_out  (a_bus),
        .b_out  (b_bus)
    );

    systolic_array #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH (ACC_WIDTH),
        .ROWS      (ROWS),
        .COLS      (COLS)
    ) u_tensor_array (
        .clk       (clk),
        .rst_n     (rst_n),
        .valid_in  (tensor_valid),
        .clear_acc (tensor_clear),
        .a_in      (a_bus),
        .b_in      (b_bus),
        .acc_out   (tensor_out),
        .valid_out ()
    );

    // ============================================================
    // Vector path (v2)
    // ============================================================
    logic vector_busy;
    logic vector_done;

    vector_unit #(
        .DATA_WIDTH(DATA_WIDTH),
        .LANES     (LANES)
    ) u_vector (
        .clk     (clk),
        .rst_n   (rst_n),
        .start   (vector_start),
        .op      (vector_op),
        .busy    (vector_busy),
        .done    (vector_done),
        .vec_a   (vector_a),
        .vec_b   (vector_b),
        .vec_acc (vector_acc),
        .vec_out (vector_out)
    );

    // ============================================================
    // Arbitration / Status
    // ============================================================
    always_comb begin
        busy = 1'b0;
        done = 1'b0;

        if (cmd_valid) begin
            case (cmd_type)
                2'b01: begin // tensor
                    busy = ~tensor_done;
                    done = tensor_done;
                end
                2'b10: begin // vector
                    busy = vector_busy;
                    done = vector_done;
                end
                default: begin
                    busy = 1'b0;
                    done = 1'b0;
                end
            endcase
        end
    end

endmodule
