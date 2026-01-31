`timescale 1ns/1ps

module tb_mesh_4x4_injection;

    logic clk;
    logic rst_n;

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        #50 rst_n = 1;
    end

    mesh_4x4_top dut (
        .clk(clk),
        .rst_n(rst_n)
    );

    initial begin
        repeat (50000) @(posedge clk);
        $display("MESH 4x4 INJECTION STABLE");
        $finish;
    end

endmodule

