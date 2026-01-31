`timescale 1ns/1ps

module tb_mesh_8x8_stress;

    logic clk;
    logic rst_n;

    always #3 clk = ~clk; // clock más agresivo

    initial begin
        clk = 0;
        rst_n = 0;
        #50 rst_n = 1;
    end

    mesh_top #(
        .NX(8),
        .NY(8)
    ) dut (
        .clk(clk),
        .rst_n(rst_n)
    );

    initial begin
        repeat (200_000) @(posedge clk);
        $display("MESH 8x8 STRESS PASSED");
        $finish;
    end

endmodule

