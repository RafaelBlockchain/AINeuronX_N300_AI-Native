`timescale 1ns/1ps

module stress_test;

    logic clk;
    integer i;

    always #1 clk = ~clk;

    initial begin
        clk = 0;
        $display("[STRESS] Inicio stress test");
        for (i = 0; i < 1000; i = i + 1) begin
            #2;
        end
        $display("[STRESS] Fin stress test");
        $finish;
    end

endmodule
