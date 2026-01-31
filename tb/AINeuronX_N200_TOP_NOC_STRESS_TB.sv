`timescale 1ns/1ps

module AINeuronX_N200_TOP_NOC_STRESS_TB;

    parameter DW = 16;
    parameter MAX_CYCLES = 5000;

    logic clk;
    logic rst_n;
    logic global_enable;

    logic in_valid;
    logic [DW-1:0] in_data;
    logic in_ready;

    logic out_valid;
    logic [DW-1:0] out_data;
    logic out_ready;

    integer sent;
    integer received;
    integer cycles;

    // Clock
    initial clk = 0;
    always #5 clk = ~clk;

    // DUT
    AINeuronX_N200_TOP dut (
        .clk_main(clk),
        .rst_n(rst_n),
        .global_enable(global_enable),
        .in_valid(in_valid),
        .in_data(in_data),
        .in_ready(in_ready),
        .out_valid(out_valid),
        .out_data(out_data),
        .out_ready(out_ready)
    );

    initial begin
        rst_n = 0;
        global_enable = 0;
        in_valid = 0;
        in_data = 0;
        out_ready = 1;
        sent = 0;
        received = 0;
        cycles = 0;

        repeat (10) @(posedge clk);
        rst_n = 1;
        global_enable = 1;

        // Saturación continua
        fork
            // Inyección
            begin
                while (cycles < MAX_CYCLES) begin
                    @(posedge clk);
                    if (in_ready) begin
                        in_valid <= 1;
                        in_data  <= sent[DW-1:0];
                        sent++;
                    end else begin
                        in_valid <= 0;
                    end
                end
            end

            // Backpressure salida
            begin
                while (cycles < MAX_CYCLES) begin
                    @(posedge clk);
                    out_ready <= (cycles % 8 != 0); // congestión artificial
                end
            end

            // Conteo de ciclos
            begin
                while (cycles < MAX_CYCLES) begin
                    @(posedge clk);
                    cycles++;
                    if (out_valid && out_ready)
                        received++;
                end
            end
        join

        $display("---- NOC STRESS RESULT ----");
        $display("Cycles   : %0d", cycles);
        $display("Sent     : %0d", sent);
        $display("Received : %0d", received);
        $display("----------------------------");

        $finish;
    end

endmodule
