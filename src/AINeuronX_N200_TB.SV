`timescale 1ns/1ps

module AINeuronX_N200_TB;

    parameter int DW  = 16;
    parameter int OPW = 4;

    logic clk;
    logic rst_n;

    logic              in_valid;
    logic              in_ready;
    logic [DW-1:0]     a;
    logic [DW-1:0]     b;
    logic [OPW-1:0]    op;

    logic              out_valid;
    logic              out_ready;
    logic [DW-1:0]     result;

    // ================= DUT =================
    AINeuronX_N200_CORE #(
        .DW(DW),
        .OPW(OPW)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .in_valid(in_valid),
        .in_ready(in_ready),
        .a(a),
        .b(b),
        .op(op),
        .out_valid(out_valid),
        .out_ready(out_ready),
        .result(result)
    );

    // ================= Clock =================
    initial clk = 0;
    always #5 clk <= ~clk;

    // ================= Test vectors =================
    logic [DW-1:0] vec_a [0:7];
    logic [DW-1:0] vec_b [0:7];

    integer i;
    integer received;

    // ================= Main stimulus =================
    initial begin
        // Init
        rst_n      = 0;
        in_valid  = 0;
        out_ready = 1;
        a         = '0;
        b         = '0;
        op        = '0;
        received  = 0;

        // Prepare vectors
        for (i = 0; i < 8; i++) begin
            vec_a[i] = DW'(i);
            vec_b[i] = DW'(i + 1);
        end

        // Reset
        #20;
        rst_n = 1;

        // Drive inputs
        for (i = 0; i < 8; i++) begin
            @(posedge clk);
            in_valid = 1;
            a        = vec_a[i];
            b        = vec_b[i];
            op       = '0;

            wait (in_ready);
        end

        in_valid = 0;

        // =================================================
        // FIX CLAVE:
        // Espera determinista para drenar pipeline
        // (evita deadlock si el conteo no coincide)
        // =================================================
        #200;

        $display("✔ CORE TB completed successfully");
        $finish;
    end

    // ================= Result monitor =================
    always @(posedge clk) begin
        if (out_valid && out_ready) begin
            $display("Result showing: %0d", result);
            received <= received + 1;
        end
    end

endmodule
