// =====================================================
// TB_AINEURONX_FULL_PIPELINE.SV
// Testbench completo: Golden Model + Checks + Asserts + Pipeline Metrics
// =====================================================
`timescale 1ns/1ps

module tb_aineuronx_full;

    // -------------------------------------------------
    // Parámetros
    // -------------------------------------------------
    parameter DATA_WIDTH_FP16 = 16;
    parameter DATA_WIDTH_FP8  = 8;
    parameter CLK_PERIOD = 10; // ns

    // -------------------------------------------------
    // Señales de clock, reset y control
    // -------------------------------------------------
    reg clk;
    reg rst_n;
    reg valid_in;
    reg select_precision; // 0 = FP16, 1 = FP8

    // Entradas del chip
    reg [DATA_WIDTH_FP16-1:0] input_a;
    reg [DATA_WIDTH_FP16-1:0] input_b;

    // Salidas del chip
    wire [DATA_WIDTH_FP16-1:0] output_chip;
    wire ready_chip;

    // Contador de ciclos
    integer cycle_count;

    // -------------------------------------------------
    // Instanciación del RTL
    // -------------------------------------------------
    aineuronx_chip uut (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .select_precision(select_precision),
        .input_a(input_a),
        .input_b(input_b),
        .output_chip(output_chip),
        .ready_chip(ready_chip)
    );

    // -------------------------------------------------
    // Clock
    // -------------------------------------------------
    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // -------------------------------------------------
    // Contador de ciclos
    // -------------------------------------------------
    always @(posedge clk) begin
        if (!rst_n)
            cycle_count <= 0;
        else
            cycle_count <= cycle_count + 1;
    end

    // -------------------------------------------------
    // Reset y estímulo inicial
    // -------------------------------------------------
    initial begin
        rst_n = 0;
        valid_in = 0;
        select_precision = 0;
        input_a = 0;
        input_b = 0;

        #(CLK_PERIOD*5);
        rst_n = 1;

        // Estímulo de prueba
        integer i;
        for (i=0; i<20; i=i+1) begin
            @(posedge clk);
            valid_in <= 1;
            input_a <= $urandom_range(1,100);
            input_b <= $urandom_range(1,100);
            select_precision <= $urandom_range(0,1);
            @(posedge clk);
            valid_in <= 0;
        end

        // Esperar flush final
        repeat(10) @(posedge clk);

        $display("✔ Testbench completado sin errores de estímulo");
    end

    // =====================================================
    // GOLDEN MODEL (referencia funcional)
    // =====================================================
    reg [DATA_WIDTH_FP16-1:0] golden_out;
    always @(*) begin
        if (select_precision == 1'b0) begin
            // FP16 (modelo simple)
            golden_out = input_a * input_b;
        end else begin
            // FP8 (modelo simplificado: truncamiento)
            golden_out = input_a[DATA_WIDTH_FP8-1:0] *
                         input_b[DATA_WIDTH_FP8-1:0];
        end
    end

    // =====================================================
    // CHECK FUNCIONAL CONTRA GOLDEN
    // =====================================================
    integer total_mismatches = 0;
    always @(posedge clk) begin
        if (rst_n && valid_in && ready_chip) begin
            if (output_chip !== golden_out) begin
                $display("❌ MISMATCH | ciclo=%0d | input_a=%0d input_b=%0d | golden=%0d got=%0d",
                        cycle_count, input_a, input_b, golden_out, output_chip);
                total_mismatches = total_mismatches + 1;
            end
        end
    end

    // =====================================================
    // ASSERTS INDUSTRIALES
    // =====================================================
    // 1) Ready nunca sin valid previo
    assert_ready_valid: assert property (@(posedge clk)
        ready_chip |-> $past(valid_in)
    ) else $error("❌ ready sin valid previo");

    // 2) Output nunca indefinido cuando ready
    assert_no_x: assert property (@(posedge clk)
        ready_chip |-> !$isunknown(output_chip)
    ) else $error("❌ output con X/Z cuando ready");

    // 3) Reset limpia el estado
    assert_reset_clean: assert property (@(posedge clk)
        !rst_n |-> !ready_chip
    ) else $error("❌ ready activo durante reset");

    // =====================================================
    // PIPELINE METRICS
    // =====================================================
    integer total_stalls = 0;
    integer total_backpressure = 0;
    integer input_cycle[$];
    integer output_cycle[$];

    always @(posedge clk) begin
        if (valid_in) input_cycle.push_back(cycle_count);
        if (valid_in && !ready_chip) total_stalls = total_stalls + 1;
        if (ready_chip) output_cycle.push_back(cycle_count);
        if (ready_chip && !valid_in) total_backpressure = total_backpressure + 1;
    end

    // =====================================================
    // LOG CICLO A CICLO
    // =====================================================
    initial begin
        $display("Ciclo | input_a | input_b | output_chip | golden_out | valid_in | ready_chip");
    end

    always @(posedge clk) begin
        if (rst_n && valid_in) begin
            $display("%0d | %0d | %0d | %0d | %0d | %b | %b",
                     cycle_count, input_a, input_b, output_chip, golden_out, valid_in, ready_chip);
        end
    end

    // =====================================================
    // RESUMEN FINAL
    // =====================================================
    initial begin
        # (CLK_PERIOD*500); // esperar a que termine todo el estímulo

        integer i, lat, min_lat=1000, max_lat=0, sum_lat=0;
        for (i=0; i<$size(input_cycle); i=i+1) begin
            lat = output_cycle[i] - input_cycle[i];
            sum_lat += lat;
            if (lat < min_lat) min_lat = lat;
            if (lat > max_lat) max_lat = lat;
        end

        $display("===================================");
        $display("SIMULATION PIPELINE METRICS SUMMARY");
        $display("Total ciclos simulados     : %0d", cycle_count);
        $display("Total mismatches           : %0d", total_mismatches);
        $display("Total stalls               : %0d", total_stalls);
        $display("Total backpressure         : %0d", total_backpressure);
        $display("Latencia mínima            : %0d ciclos", min_lat);
        $display("Latencia máxima            : %0d ciclos", max_lat);
        $display("Latencia promedio          : %0.2f ciclos", sum_lat*1.0/$size(input_cycle));
        $display("===================================");

        $stop;
    end

endmodule

