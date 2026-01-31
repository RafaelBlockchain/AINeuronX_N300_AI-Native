`timescale 1ns/1ps

module tb_mesh_4x4_congestion;

    logic clk;
    logic rst_n;

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

    initial begin
        repeat (100000) @(posedge clk);
        $display("MESH 4x4 CONGESTION TEST PASSED");
        $finish;
    end

endmodule

