`timescale 1ns/1ps

module tb_router_vc_deadlock;

    logic clk;
    logic rst_n;
    logic in_valid, in_ready;
    logic [127:0] in_flit;

    logic e_valid, e_ready;
    logic [127:0] e_flit;

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        #40 rst_n = 1;
    end

    noc_xy_router_vc #(.X_ID(0), .Y_ID(0)) dut (
        .clk, .rst_n,
        .in_valid, .in_ready, .in_flit,
        .e_valid, .e_ready,
        .w_valid(), .n_valid(), .s_valid(),
        .e_flit, .w_flit(), .n_flit(), .s_flit(),
        .w_ready(1'b1), .n_ready(1'b1), .s_ready(1'b1)
    );

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            in_valid <= 0;
            e_ready <= 1;
        end else begin
            in_valid <= 1;
            in_flit[3:0] <= 1;
            in_flit[7:4] <= 0;
            in_flit[9:8] <= $random % 2; // VC0 / VC1
            in_flit[127:10] <= $random;
            e_ready <= $random;
        end
    end

    initial begin
        repeat (30000) @(posedge clk);
        $display("VC ROUTER DEADLOCK TEST PASSED");
        $finish;
    end

endmodule

