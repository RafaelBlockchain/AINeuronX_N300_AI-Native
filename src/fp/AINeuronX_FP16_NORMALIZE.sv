module AINeuronX_FP16_NORMALIZE (
    input  logic signed [11:0] mantissa_in,
    input  logic [5:0] exponent_in,
    output logic signed [9:0] mantissa_out,
    output logic [4:0] exponent_out,
    output logic guard, round, sticky
);

    logic [11:0] m;
    logic [5:0]  e;

    always_comb begin
        m = mantissa_in;
        e = exponent_in;

        if (m[11]) begin
            m = m >> 1;
            e = e + 1;
        end else begin
            while (!m[10] && e > 0) begin
                m = m << 1;
                e = e - 1;
            end
        end

        mantissa_out = m[10:1];
        guard  = m[0];
        round  = 1'b0;
        sticky = 1'b0;
        exponent_out = e[4:0];
    end
endmodule
