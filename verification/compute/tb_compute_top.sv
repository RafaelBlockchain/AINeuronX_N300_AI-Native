`timescale 1ns/1ps

module tb_compute_top;

    logic clk;
    logic rst_n;

    // Scheduler → Tensor
    logic        op_valid;
    logic        op_ready;
    logic [3:0]  op_opcode;
    logic [2:0]  op_fmt;
    logic [7:0]  op_tile_cfg;

    // Memory
    logic        mem_req_valid;
    logic        mem_req_ready;
    logic [63:0] mem_addr;
    logic [255:0] mem_rdata;

    // Writeback
    logic        wb_valid;
    logic        wb_ready;
    logic [63:0] wb_addr;
    logic [255:0] wb_data;

    logic done;
    logic stall;

    // Clock
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        #50;
        rst_n = 1;
    end

    // DUT
    compute_top dut (
        .clk(clk),
        .rst_n(rst_n),

        .op_valid(op_valid),
        .op_ready(op_ready),
        .op_opcode(op_opcode),
        .op_fmt(op_fmt),
        .op_tile_cfg(op_tile_cfg),

        .mem_req_valid(mem_req_valid),
        .mem_req_ready(mem_req_ready),
        .mem_addr(mem_addr),
        .mem_rdata(mem_rdata),

        .wb_valid(wb_valid),
        .wb_ready(wb_ready),
        .wb_addr(wb_addr),
        .wb_data(wb_data),

        .done(done),
        .stall(stall)
    );

    // Memory mock
    mem_mock mem (
        .clk(clk),
        .rst_n(rst_n),
        .req_valid(mem_req_valid),
        .req_ready(mem_req_ready),
        .addr(mem_addr),
        .rdata(mem_rdata)
    );

    // Writeback always ready (directed)
    assign wb_ready = 1'b1;

    // Directed test
    initial begin
        wait(rst_n);

        @(posedge clk);
        op_opcode   <= 4'h1; // GEMM
        op_fmt      <= 3'b010; // FP8 E4M3
        op_tile_cfg <= 8'h10;
        op_valid    <= 1'b1;

        wait(op_ready);
        @(posedge clk);
        op_valid <= 0;

        wait(done);
        #50;

        $display("TEST PASSED");
        $finish;
    end

endmodule

