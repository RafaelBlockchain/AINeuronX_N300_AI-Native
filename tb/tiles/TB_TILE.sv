`timescale 1ns/1ps

module TB_TILE;

    localparam int DATA_WIDTH = 16;
    localparam int ACC_WIDTH  = 32;
    localparam int ROWS = 4;
    localparam int COLS = 4;
    localparam int K_DIM = 8;
    localparam int LANES = 4;

    logic clk;
    logic rst_n;

    // Command
    logic        cmd_valid;
    logic [1:0]  cmd_type;
    logic        cmd_start;
    logic        busy;
    logic        done;

    // Tensor
    logic        tensor_load;
    logic        tensor_start;
    logic signed [DATA_WIDTH-1:0] tensor_a [ROWS-1:0][K_DIM-1:0];
    logic signed [DATA_WIDTH-1:0] tensor_b [K_DIM-1:0][COLS-1:0];
    logic signed [ACC_WIDTH-1:0]  tensor_out [ROWS-1:0][COLS-1:0];

    // Vector
    logic        vector_start;
    logic [1:0]  vector_op;
    logic signed [DATA_WIDTH-1:0] vector_a   [LANES-1:0];
    logic signed [DATA_WIDTH-1:0] vector_b   [LANES-1:0];
    logic signed [DATA_WIDTH-1:0] vector_acc [LANES-1:0];
    logic signed [DATA_WIDTH-1:0] vector_out [LANES-1:0];

    // Clock
    initial clk = 0;
    always #5 clk = ~clk;

    // DUT
    Tile_Core_Compute #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH (ACC_WIDTH),
        .ROWS      (ROWS),
        .COLS      (COLS),
        .K_DIM     (K_DIM),
        .LANES     (LANES)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),

        .cmd_valid(cmd_valid),
        .cmd_type (cmd_type),
        .cmd_start(cmd_start),
        .busy     (busy),
        .done     (done),

        .tensor_load (tensor_load),
        .tensor_start(tensor_start),
        .tensor_a    (tensor_a),
        .tensor_b    (tensor_b),
        .tensor_out  (tensor_out),

        .vector_start(vector_start),
        .vector_op   (vector_op),
        .vector_a    (vector_a),
        .vector_b    (vector_b),
        .vector_acc  (vector_acc),
        .vector_out  (vector_out)
    );

    integer i, j;

    initial begin
        // Reset
        rst_n = 0;
        cmd_valid = 0;
        cmd_start = 0;
        tensor_load = 0;
        tensor_start = 0;
        vector_start = 0;
        #20;
        rst_n = 1;

        // ===============================
        // Load tensor data
        // ===============================
        for (i = 0; i < ROWS; i++)
            for (j = 0; j < K_DIM; j++)
                tensor_a[i][j] = 1;

        for (i = 0; i < K_DIM; i++)
            for (j = 0; j < COLS; j++)
                tensor_b[i][j] = 1;

        tensor_load = 1;
        #10;
        tensor_load = 0;

        // ===============================
        // Run tensor (matmul)
        // ===============================
        cmd_valid   = 1;
        cmd_type    = 2'b01; // tensor
        tensor_start= 1;
        #10;
        tensor_start= 0;

        wait(done);
        #10;

        // ===============================
        // Vector epilogue (bias add)
        // ===============================
        for (i = 0; i < LANES; i++) begin
            vector_a[i]   = tensor_out[0][i];
            vector_b[i]   = 1;
            vector_acc[i] = 0;
        end

        cmd_type     = 2'b10; // vector
        vector_op    = 2'b00; // ADD
        vector_start = 1;
        #10;
        vector_start = 0;

        #20;

        $display("=== VECTOR OUTPUT ===");
        for (i = 0; i < LANES; i++)
            $display("lane %0d = %0d", i, vector_out[i]);

        $finish;
    end

endmodule
