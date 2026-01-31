`timescale 1ns/1ps

module directed_test_basic;

    logic clk;

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        $display("[DIRECTED] Test básico iniciado");
        #200;
        $display("[DIRECTED] Test básico finalizado");
        $finish;
    end

endmodule
