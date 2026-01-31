module AINeuronX_CLK_GATE (
    input  logic clk_in,
    input  logic enable,
    output logic clk_out
);
    logic en_latched;

    always_latch begin
        if (!clk_in)
            en_latched <= enable;
    end

    assign clk_out = clk_in & en_latched;
endmodule
