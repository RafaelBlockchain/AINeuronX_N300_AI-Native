`timescale 1ns/1ps

module AINeuronX_N200_TOP_ROOFLINE_TB;

    parameter DW = 16;
    parameter WARMUP = 100;
    parameter MEASURE = 2000;

    logic clk, rst_n, global_enable;
    logic in_valid, in_ready;
    logic [DW-1:0] in_data;
    logic out_valid, out_ready;
    logic [DW-1:0] out_data;

    integer sent, received, cycles;

    initial clk = 0;
    always #5 clk = ~clk;

    AINeuronX_N200_TOP dut (
        .clk_main(clk),
        .rst_n(rst_n),
        .global_enable(global_enable),
        .in_valid(in_valid),
        .in_data(in_data),
        .in_ready(in_ready),
        .out_valid(out_valid),
        .out_data(out_data),
        .out_ready(out_ready)
    );

    initial begin
        rst_n = 0;
        global_enable = 0;
        in_valid = 0;
        out_ready = 1;
        sent = 0;
        received = 0;
        cycles = 0;

        repeat (10) @(posedge clk);
        rst_n = 1;
        global_enable = 1;

        // Warmup
        repeat (WARMUP) @(posedge clk);

        // Medición
        while (cycles < MEASURE) begin
            @(posedge clk);
            cycles++;

            if (in_ready) begin
                in_valid <= 1;
                in_data  <= sent;
                sent++;
            end

            if (out_valid && out_ready)
                received++;
        end

        $display("---- ROOFLINE ----");
        $display("Cycles      : %0d", cycles);
        $display("Sent        : %0d", sent);
        $display("Received    : %0d", received);
        $display("Throughput  : %f pkt/cycle",
                 real'(received)/real'(cycles));
        $display("------------------");

        $finish;
    end

endmodule
