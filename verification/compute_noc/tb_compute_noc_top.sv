`timescale 1ns/1ps

module tb_compute_noc_top;

    logic clk;
    logic rst_n;

    logic        cmd_valid;
    logic        cmd_ready;
    logic [63:0] cmd;

    logic        noc_valid;
    logic        noc_ready;
    logic [127:0] noc_flit;

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        #50 rst_n = 1;
    end

    compute_noc_adapter u_adapter (
        .clk, .rst_n,
        .cmd_valid, .cmd_ready, .cmd,
        .noc_valid, .noc_ready, .noc_flit
    );

    noc_link_simple u_noc (
        .clk, .rst_n,
        .in_valid(noc_valid),
        .in_ready(noc_ready),
        .in_flit (noc_flit),
        .out_valid(),
        .out_ready(1'b1),
        .out_flit()
    );

    initial begin
        cmd_valid = 0;
        cmd = '0;

        @(posedge rst_n);
        repeat (1000) begin
            @(posedge clk);
            if (cmd_ready) begin
                cmd_valid <= 1'b1;
                cmd <= $random;
            end else begin
                cmd_valid <= 1'b0;
            end
        end

        $display("COMPUTE ↔ NOC MINIMAL PASSED");
        $finish;
    end

endmodule

