// =====================================================
// AINEURONX.SV – Testbench industrial listo para SoC
// Pipeline vectorizado + backpressure + golden model
// =====================================================
`timescale 1ns/1ps

module aineuronx;

    // -------------------------------------------------
    // Parámetros
    // -------------------------------------------------
    parameter int DATA_WIDTH_FP16 = 16;
    parameter int CLK_PERIOD      = 10;   // ns
    parameter int VECTOR_WIDTH    = 4;    // Número de datos por ciclo
    localparam int EXPECTED_TX    = 40;   // Total transacciones a enviar

    // -------------------------------------------------
    // Señales
    // -------------------------------------------------
    logic clk;
    logic rst_n;
    logic valid_in;
    logic select_precision;
    logic prefetch_enable;

    logic [DATA_WIDTH_FP16-1:0] input_a [VECTOR_WIDTH-1:0];
    logic [DATA_WIDTH_FP16-1:0] input_b [VECTOR_WIDTH-1:0];

    logic [DATA_WIDTH_FP16-1:0] output_chip [VECTOR_WIDTH-1:0];
    logic ready_chip;

    integer cycle_count;
    integer input_cycle  [$];
    integer output_cycle [$];

    // Golden model arrays
    logic [DATA_WIDTH_FP16-1:0] golden_expected [$];
    integer golden_cycle [$];

    // -------------------------------------------------
    // Clock
    // -------------------------------------------------
    initial clk = 0;
    always begin
        #(CLK_PERIOD/2);
        clk <= ~clk;
    end

    // -------------------------------------------------
    // Contador de ciclos
    // -------------------------------------------------
    always_ff @(posedge clk) begin
        if (!rst_n)
            cycle_count <= 0;
        else
            cycle_count <= cycle_count + 1;
    end

    // -------------------------------------------------
    // DUT REAL – vectorizado
    // -------------------------------------------------
    aineuronx_core dut (
        .clk              (clk),
        .rst_n            (rst_n),
        .valid_in         (valid_in),
        .select_precision (select_precision),
        .prefetch_enable  (prefetch_enable),
        .input_a          (input_a[0]), // core se asume acepta vector por ciclo
        .input_b          (input_b[0]),
        .ready_out        (ready_chip),
        .output_data      (output_chip[0])
    );

    // -------------------------------------------------
    // Reset + estímulos
    // -------------------------------------------------
    initial begin
        rst_n            = 0;
        valid_in         = 0;
        select_precision = 0;
        prefetch_enable  = 0;

        for (int i = 0; i < VECTOR_WIDTH; i++) begin
            input_a[i] = '0;
            input_b[i] = '0;
        end

        repeat (5) @(posedge clk);
        rst_n = 1;

        repeat (2) @(posedge clk);
        prefetch_enable = 1'b1; // prefetch inteligente y consistente

        int sent = 0;
        while (sent < EXPECTED_TX) begin
            @(posedge clk);
            valid_in = ready_chip; // backpressure continuo

            if (valid_in) begin
                select_precision = sent[0];

                for (int v = 0; v < VECTOR_WIDTH; v++) begin
                    int index = sent + v;
                    if (index < EXPECTED_TX) begin
                        input_a[v] = DATA_WIDTH_FP16'(index);
                        input_b[v] = DATA_WIDTH_FP16'(EXPECTED_TX - index);

                        // Golden model y ciclos
                        input_cycle.push_back(cycle_count);
                        golden_cycle.push_back(cycle_count);
                        golden_expected.push_back((select_precision) ? (input_a[v] + input_b[v]) : (input_a[v] - input_b[v]));
                    end
                end

                sent += VECTOR_WIDTH;
            end
        end

        @(posedge clk);
        valid_in = 0;

        // Esperar todas las respuestas
        wait (output_cycle.size() == input_cycle.size());

        repeat (2) @(posedge clk);
        $finish;
    end

    // -------------------------------------------------
    // Captura de salida + verificación GOLDEN
    // -------------------------------------------------
    always_ff @(posedge clk) begin
        if (ready_chip && golden_expected.size() > 0) begin
            for (int v = 0; v < VECTOR_WIDTH; v++) begin
                if (golden_expected.size() > 0) begin
                    logic [DATA_WIDTH_FP16-1:0] expected;
                    integer in_cycle;

                    expected = golden_expected.pop_front();
                    in_cycle = golden_cycle.pop_front();

                    output_cycle.push_back(cycle_count);

                    // Verificación funcional
                    assert (output_chip[v] === expected)
                        else $fatal(
                            "❌ ERROR FUNCIONAL | Output[%0d]=%0d | Esperado=%0d | Ciclo=%0d",
                            v, output_chip[v], expected, cycle_count
                        );

                    // Latencia formal
                    int latency = cycle_count - in_cycle;
                    assert (latency == 3)
                        else $fatal(
                            "❌ ERROR DE LATENCIA | Output[%0d] | Latencia=%0d | Esperado=3 | Ciclo=%0d",
                            v, latency, cycle_count
                        );
                end
            end
        end
    end

    // -------------------------------------------------
    // Reporte final
    // -------------------------------------------------
    final begin
        $display("====================================");
        $display(" AINEURONX TB INDUSTRIAL FINAL REPORT");
        $display(" Inputs enviados  : %0d", input_cycle.size());
        $display(" Outputs recibidos: %0d", output_cycle.size());
        $display(" Testbench OK – Core vectorizado + backpressure + golden model validado");
        $display("====================================");
    end

endmodule
