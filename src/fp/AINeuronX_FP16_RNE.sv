module AINeuronX_FP16_RNE (
    input  logic signed [9:0] mantissa_in,
    input  logic guard,
    input  logic round,
    input  logic sticky,
    output logic signed [9:0] mantissa_out
);
    always_comb begin
        mantissa_out = mantissa_in;
        if (guard && (round | sticky | mantissa_in[0]))
            mantissa_out = mantissa_in + 1;
    end
endmodule
