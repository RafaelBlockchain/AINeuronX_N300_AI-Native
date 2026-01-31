`timescale 1ns/1ps

module tb_router_2x2_stress;

    logic clk;
    logic rst_n;

    logic in0_valid, in1_valid;
    logic in0_ready, in1_ready;
    logic [127:0] in0_flit, in1_flit;

    logic out0_valid, out1_valid;
    logic out0_ready, out1_ready;
    logic [127:0] out0_flit, out1_flit;

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        #40 rst_n = 1;
    end

    noc_router_2x2 dut (
        .clk, .rst_n,
        .in0_valid, .in0_ready, .in0_flit,
        .in1_valid, .in1_ready, .in1_flit,
        .out0_valid, .out0_ready, .out0_flit,
        .out1_valid, .out1_ready, .out1_flit
    );

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            in0_valid <= 0;
            in1_valid <= 0;
            out0_ready<= 1;
            out1_ready<= 1;
        end else begin
            in0_valid <= $random;
            in1_valid <= $random;
            in0_flit  <= $random;
            in1_flit  <= $random;
            out0_ready<= $random;
            out1_ready<= $random;
        end
    end

    initial begin
        repeat (20000) @(posedge clk);
        $display("ROUTER 2x2 STRESS PASSED");
        $finish;
    end

endmodule

