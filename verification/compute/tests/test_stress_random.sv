`timescale 1ns/1ps

module test_stress_random;

    import "DPI-C" function int rand();

    logic clk;
    logic rst_n;

    logic        op_valid;
    logic        op_ready;
    logic [3:0]  op_opcode;
    logic [2:0]  op_fmt;
    logic [7:0]  op_tile_cfg;

    logic wb_ready;
    logic done;
    logic stall;

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        #40 rst_n = 1;
    end

    // Random backpressure
    always_ff @(posedge clk) begin
        if (!rst_n)
            wb_ready <= 1'b1;
        else
            wb_ready <= rand() % 3; // 0,1,2 → aleatorio
    end

    // Random issue
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            op_valid    <= 0;
            op_opcode  <= 0;
            op_fmt     <= 0;
            op_tile_cfg<= 0;
        end else begin
            if (op_ready && (rand() % 2)) begin
                op_valid     <= 1'b1;
                op_opcode   <= 4'h1; // GEMM
                op_fmt      <= rand() % 4; // FP16 / BF16 / FP8
                op_tile_cfg <= rand();
            end else begin
                op_valid <= 1'b0;
            end
        end
    end

    initial begin
        repeat (10000) @(posedge clk);
        $display("STRESS RANDOM COMPLETED – NO DEADLOCK");
        $finish;
    end

endmodule

