// ====================================================================
// TB para AINeuronX_FP8_MAC
// Stage0 Decode FP8 (E4M3 / E5M2)
// ====================================================================

`timescale 1ns/1ps

module AINeuronX_FP8_MAC_TB;

    // --------------------------------------------------
    // Señales
    // --------------------------------------------------
    logic clk;
    logic rst_n;

    logic in_valid;
    logic [7:0] a_fp8;
    logic [7:0] b_fp8;
    logic in_ready;

    logic out_valid;
    logic [15:0] acc_fp16;
    logic clear_acc;

    // --------------------------------------------------
    // Instancia del DUT
    // --------------------------------------------------
    AINeuronX_FP8_MAC dut (
        .clk(clk),
        .rst_n(rst_n),
        .in_valid(in_valid),
        .a_fp8(a_fp8),
        .b_fp8(b_fp8),
        .in_ready(in_ready),
        .out_valid(out_valid),
        .acc_fp16(acc_fp16),
        .clear_acc(clear_acc)
    );

    // --------------------------------------------------
    // Generación de reloj
    // --------------------------------------------------
    initial clk = 0;
    always #5 clk = ~clk;

    // --------------------------------------------------
    // Inicialización
    // --------------------------------------------------
    initial begin
        rst_n = 0;
        in_valid = 0;
        a_fp8 = 0;
        b_fp8 = 0;
        clear_acc = 1;

        #20;
        rst_n = 1;
        clear_acc = 0;

        // --------------------------------------------------
        // Aplicar estímulos aleatorios
        // --------------------------------------------------
        repeat (50) begin
            @(posedge clk);
            in_valid <= 1;
            a_fp8 <= $urandom_range(0,255);
            b_fp8 <= $urandom_range(0,255);
            @(posedge clk);
            in_valid <= 0;
            @(posedge clk);
        end

        // Finaliza simulación
        #100;
        $display("[FP8 MAC TB] Simulación terminada");
        $finish;
    end

    // --------------------------------------------------
    // Monitor
    // --------------------------------------------------
    always @(posedge clk) begin
        if (out_valid) begin
            $display("[%0t] a=%h b=%h acc=%h", $time, a_fp8, b_fp8, acc_fp16);
        end
    end

endmodule
