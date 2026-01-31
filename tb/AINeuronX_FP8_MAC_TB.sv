`timescale 1ns/1ps

module AINeuronX_FP8_MAC_TB;

    logic clk;
    logic rst_n;

    logic        in_valid;
    logic [7:0]  a_fp8;
    logic [7:0]  b_fp8;

    logic        in_ready;
    logic        out_valid;
    logic [15:0] acc_fp16;

    logic clear_acc;

    // =============================
    // PARAMETRO DE MODO
    // =============================
    localparam MODE = 0; // 0=E4M3, 1=E5M2

    // =============================
    // DUT
    // =============================
    AINeuronX_FP8_MAC #(
        .MODE(MODE)
    ) dut (
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

    // =============================
    // CLOCK
    // =============================
    initial clk = 0;
    always #5 clk = ~clk;

    // =============================
    // GOLDEN MODEL (DECODE)
    // =============================
    function automatic signed [6:0] golden_exp(input [7:0] fp8);
        if (MODE == 0)
            golden_exp = (fp8[6:0] == 0) ? 0 : $signed({1'b0, fp8[6:3]}) - 7;
        else
            golden_exp = (fp8[6:0] == 0) ? 0 : $signed({1'b0, fp8[6:2]}) - 15;
    endfunction

    function automatic [5:0] golden_mant(input [7:0] fp8);
        if (fp8[6:0] == 0)
            golden_mant = 0;
        else if (MODE == 0)
            golden_mant = {1'b1, fp8[2:0], 2'b00};
        else
            golden_mant = {1'b1, fp8[1:0], 3'b000};
    endfunction

    // =============================
    // TEST
    // =============================
    integer i, j;

    initial begin
        rst_n     = 0;
        in_valid = 0;
        a_fp8    = 0;
        b_fp8    = 0;
        clear_acc = 0;

        repeat (5) @(posedge clk);
        rst_n = 1;

        $display("▶ Starting FP8 Decode Exhaustive Test");

        for (i = 0; i < 256; i++) begin
            for (j = 0; j < 256; j++) begin
                @(posedge clk);
                in_valid = 1;
                a_fp8    = i[7:0];
                b_fp8    = j[7:0];

                @(posedge clk);
                in_valid = 0;

                // Esperar salida de etapa 0
                @(posedge clk);

                // Verificación A
                if (dut.exp_a_0 !== golden_exp(i)) begin
                    $error("EXP A mismatch: fp8=%h dut=%0d golden=%0d",
                           i, dut.exp_a_0, golden_exp(i));
                    $finish;
                end

                if (dut.mant_a_0 !== golden_mant(i)) begin
                    $error("MANT A mismatch: fp8=%h dut=%b golden=%b",
                           i, dut.mant_a_0, golden_mant(i));
                    $finish;
                end

                // Verificación B
                if (dut.exp_b_0 !== golden_exp(j)) begin
                    $error("EXP B mismatch: fp8=%h dut=%0d golden=%0d",
                           j, dut.exp_b_0, golden_exp(j));
                    $finish;
                end

                if (dut.mant_b_0 !== golden_mant(j)) begin
                    $error("MANT B mismatch: fp8=%h dut=%b golden=%b",
                           j, dut.mant_b_0, golden_mant(j));
                    $finish;
                end
            end
        end

        $display("✔ FP8 Decode PASSED (MODE=%0d)", MODE);
        $finish;
    end

endmodule
