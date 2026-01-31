module AINeuronX_CLK_GATE (
    input  logic clk,
    input  logic enable,
    output logic gclk
);
    // Inferencia de ICG
    assign gclk = clk & enable;
endmodule
