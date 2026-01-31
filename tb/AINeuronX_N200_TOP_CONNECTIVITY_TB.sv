`timescale 1ns/1ps

module AINeuronX_N200_TOP_CONNECTIVITY_TB;

    parameter DW = 16;

    logic clk;
    logic rst_n;
    logic global_enable;

    logic in_valid;
    logic [DW-1:0] in_data;
    logic in_ready;

    logic out_valid;
    logic [DW-1:0] out_data;
    logic out_ready;

    // Clock
    initial clk = 0;
    always #5 clk = ~clk;

    // DUT
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
        // Init
        rst_n = 0;
        global_enable = 0;
        in_valid = 0;
        in_data = '0;
        out_ready = 1;

        repeat (5) @(posedge clk);
        rst_n = 1;
        global_enable = 1;

        @(posedge clk);

        // Inyección simple
        in_data  = 16'hA5A5;
        in_valid = 1;

        wait (in_ready);
        @(posedge clk);
        in_valid = 0;

        // Esperar salida
        wait (out_valid);

        $display("✔ DATA OUT = %h", out_data);

        repeat (10) @(posedge clk);
        $finish;
    end

endmodule
