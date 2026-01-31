`timescale 1ns/1ps

module tb_mesh_4x4_metrics;

    logic clk;
    logic rst_n;

    logic [31:0] min_lat, max_lat, sum_lat, samples;

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        #100 rst_n = 1;
    end

    mesh_4x4_cabled_top dut (
        .clk(clk),
        .rst_n(rst_n)
    );

    // Monitor global (ejemplo: observar un puerto de salida)
    noc_latency_monitor mon (
        .clk(clk),
        .rst_n(rst_n),
        .flit_valid(dut.e_valid[0][0]),
        .flit(dut.e_flit[0][0]),
        .min_latency(min_lat),
        .max_latency(max_lat),
        .sum_latency(sum_lat),
        .sample_count(samples)
    );

    initial begin
        repeat (200000) @(posedge clk);

        $display("==== AINeuronX N200 NoC METRICS ====");
        $display("Samples      : %0d", samples);
        $display("Min latency  : %0d cycles", min_lat);
        $display("Max latency  : %0d cycles", max_lat);
        if (samples > 0)
            $display("Avg latency  : %0d cycles", sum_lat / samples);
        $display("===================================");

        $finish;
    end

endmodule

