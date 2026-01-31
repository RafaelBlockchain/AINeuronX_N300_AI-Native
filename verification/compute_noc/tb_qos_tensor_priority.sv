`timescale 1ns/1ps

module tb_qos_tensor_priority;

    logic clk;
    logic rst_n;

    logic in0_valid, in1_valid;
    logic in0_ready, in1_ready;
    logic [127:0] in0_flit, in1_flit;

    logic out_valid, out_ready;
    logic [127:0] out_flit;

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        #30 rst_n = 1;
    end

    noc_output_arbiter_qos dut (
        .clk, .rst_n,
        .in0_valid, .in0_flit, .in0_ready,
        .in1_valid, .in1_flit, .in1_ready,
        .out_valid, .out_flit, .out_ready
    );

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            in0_valid <= 0;
            in1_valid <= 0;
            out_ready <= 1;
        end else begin
            // DMA
            in0_valid <= 1;
            in0_flit[11:10] <= 2'b00;

            // Tensor
            in1_valid <= 1;
            in1_flit[11:10] <= 2'b10;

            out_ready <= 1;
        end
    end

    always_ff @(posedge clk) begin
        if (out_valid)
            assert(out_flit[11:10] == 2'b10)
            else $fatal("QoS FAILED: Tensor not prioritized");
    end

    initial begin
        repeat (1000) @(posedge clk);
        $display("QOS TENSOR PRIORITY VERIFIED");
        $finish;
    end

endmodule
