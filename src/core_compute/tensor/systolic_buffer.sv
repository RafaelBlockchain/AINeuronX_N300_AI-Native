`timescale 1ns/1ps

module systolic_buffer #(
    parameter int DATA_WIDTH = 16,
    parameter int ROWS = 4,
    parameter int COLS = 4,
    parameter int K_DIM = 16
)(
    input  logic clk,
    input  logic rst_n,

    // Control
    input  logic load,
    input  logic shift,

    // Load interfaces (from Tile memory / DMA)
    input  logic signed [DATA_WIDTH-1:0] a_load [ROWS-1:0][K_DIM-1:0],
    input  logic signed [DATA_WIDTH-1:0] b_load [K_DIM-1:0][COLS-1:0],

    // Outputs to systolic array
    output logic signed [DATA_WIDTH-1:0] a_out [ROWS-1:0],
    output logic signed [DATA_WIDTH-1:0] b_out [COLS-1:0]
);

    logic signed [DATA_WIDTH-1:0] a_buf [ROWS-1:0][K_DIM-1:0];
    logic signed [DATA_WIDTH-1:0] b_buf [K_DIM-1:0][COLS-1:0];

    logic [$clog2(K_DIM)-1:0] k_ptr;

    integer r, c;

    // Load buffers
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            k_ptr <= '0;
        end else begin
            if (load) begin
                for (r = 0; r < ROWS; r++)
                    for (c = 0; c < K_DIM; c++)
                        a_buf[r][c] <= a_load[r][c];

                for (r = 0; r < K_DIM; r++)
                    for (c = 0; c < COLS; c++)
                        b_buf[r][c] <= b_load[r][c];

                k_ptr <= '0;
            end else if (shift) begin
                k_ptr <= k_ptr + 1'b1;
            end
        end
    end

    // Drive systolic inputs
    always_comb begin
        for (r = 0; r < ROWS; r++)
            a_out[r] = a_buf[r][k_ptr];

        for (c = 0; c < COLS; c++)
            b_out[c] = b_buf[k_ptr][c];
    end

endmodule
