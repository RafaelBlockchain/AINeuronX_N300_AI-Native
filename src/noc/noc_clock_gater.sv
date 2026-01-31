module noc_clock_gater (
    input  logic clk,
    input  logic rst_n,
    input  logic activity,   // OR de valid/ready internos
    output logic gclk
);
    logic en_latch;

    always_latch begin
        if (!rst_n)
            en_latch <= 1'b0;
        else
            en_latch <= activity;
    end

    assign gclk = clk & en_latch;
endmodule

