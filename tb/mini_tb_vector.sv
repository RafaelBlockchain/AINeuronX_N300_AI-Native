// =====================================================
// MINI_TB_VECTOR.SV – prueba rápida del core vectorizado
// =====================================================
`timescale 1ns/1ps

module mini_tb_vector;

    parameter int DATA_WIDTH   = 16;
    parameter int VECTOR_WIDTH = 4;
    parameter int CLK_PERIOD   = 10;

    logic clk;
    logic rst_n;
    logic valid_in;
    logic select_precision;
    logic prefetch_enable;

    logic [DATA_WIDTH-1:0] input_a [VECTOR_WIDTH-1:0];
    logic [DATA_WIDTH-1:0] input_b [VECTOR_WIDTH-1:0];
    logic [DATA_WIDTH-1:0] output_data [VECTOR_WIDTH-1:0];
    logic ready_out;

    // -------------------------------------------------
    // Clock
    // -------------------------------------------------
    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // -------------------------------------------------
    // Instancia del core vectorizado
    // -------------------------------------------------
    aineuronx_core #(
        .DATA_WIDTH(DATA_WIDTH),
        .VECTOR_WIDTH(VECTOR_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .select_precision(select_precision),
        .prefetch_enable(prefetch_enable),
        .input_a(input_a),
        .input_b(input_b),
        .ready_out(ready_out),
        .output_data(output_data)
    );

    // -------------------------------------------------
    // Estímulos
    // -------------------------------------------------
    initial begin
        rst_n = 0;
        valid_in = 0;
        select_precision = 0;
        prefetch_enable = 0;
        for (int i = 0; i < VECTOR_WIDTH; i++) begin
            input_a[i] = 0;
            input_b[i] = 0;
        end

        repeat (5) @(posedge clk);
        rst_n = 1;

        repeat (2) @(posedge clk);
        prefetch_enable = 1'b1;

        for (int cycle = 0; cycle < 10; cycle++) begin
            @(posedge clk);
            valid_in = 1'b1;
            select_precision = cycle[0]; // alterna suma/resta

            for (int i = 0; i < VECTOR_WIDTH; i++) begin
                input_a[i] = cycle + i;
                input_b[i] = 10 - i;
            end

            // imprimir outputs si ready
            if (ready_out) begin
                $display("Cycle %0d Output:", cycle);
                for (int i = 0; i < VECTOR_WIDTH; i++)
                    $write("%0d ", output_data[i]);
                $display("");
            end
        end

        @(posedge clk);
        valid_in = 0;
        repeat (2) @(posedge clk);
        $finish;
    end

endmodule
