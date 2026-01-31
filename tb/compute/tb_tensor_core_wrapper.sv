`timescale 1ns/1ps

module tb_tensor_core_wrapper;

    parameter DATA_WIDTH = 16;

    logic clk;
    logic rst_n;

    // ===== Control =====
    logic        tc_valid;
    logic [3:0]  tc_opcode;
    logic [7:0]  tc_m, tc_n, tc_k;
    logic        tc_ready;

    // ===== Memory =====
    logic        mem_req;
    logic [31:0] mem_addr;
    logic [DATA_WIDTH-1:0] mem_rdata;
    logic        mem_ready;

    // ===== Result =====
    logic        result_valid;
    logic [DATA_WIDTH-1:0] result_data;

    // ============================================================
    // DUT
    // ============================================================
    tensor_core_wrapper #(
        .DATA_WIDTH(DATA_WIDTH),
        .TILE_ID(0)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),

        .tc_valid(tc_valid),
        .tc_opcode(tc_opcode),
        .tc_m(tc_m),
        .tc_n(tc_n),
        .tc_k(tc_k),
        .tc_ready(tc_ready),

        .mem_req(mem_req),
        .mem_addr(mem_addr),
        .mem_rdata(mem_rdata),
        .mem_ready(mem_ready),

        .result_valid(result_valid),
        .result_data(result_data)
    );

    // ============================================================
    // Clock
    // ============================================================
    initial clk = 0;
    always #5 clk = ~clk;

    // ============================================================
    // Reset
    // ============================================================
    initial begin
        rst_n = 0;
        tc_valid = 0;
        mem_ready = 0;
        mem_rdata = '0;
        #20 rst_n = 1;
    end

    // ============================================================
    // Memory model (simple)
    // ============================================================
    always_ff @(posedge clk) begin
        if (mem_req) begin
            mem_ready <= 1'b1;
            mem_rdata <= 16'h1234;
        end else begin
            mem_ready <= 1'b0;
        end
    end

    // ============================================================
    // Test sequence
    // ============================================================
    initial begin
        @(posedge rst_n);
        @(posedge clk);

        // ---- Emit Tensor MATMUL ----
        tc_opcode = 4'b0001; // TC_MATMUL
        tc_m      = 8'd16;
        tc_n      = 8'd16;
        tc_k      = 8'd16;
        tc_valid  = 1'b1;

        wait (tc_ready);
        @(posedge clk);
        tc_valid = 1'b0;

        // ---- Wait for result ----
        wait (result_valid);
        $display("Tensor op completed, result = %h", result_data);

        #20;
        $finish;
    end

endmodule
