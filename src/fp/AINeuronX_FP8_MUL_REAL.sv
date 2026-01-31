module AINeuronX_FP8_MUL_REAL #(
    parameter EXP_BITS = 4
)(
    input  logic clk,
    input  logic rst_n,
    input  logic valid_in,
    input  logic [7:0] a,
    input  logic [7:0] b,
    output logic valid_out,
    output logic [15:0] result_fp16
);

    // Stage 0 decode
    logic sign;
    logic [EXP_BITS:0] exp_sum;
    logic [3:0] man_a, man_b;

    // Stage 1 Booth
    logic signed [2:0] booth;

    // Stage 2 PP
    logic signed [7:0] pp;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            valid_out <= 0;
        end else begin
            valid_out <= valid_in;

            sign <= a[7] ^ b[7];
            exp_sum <= a[6:3] + b[6:3] - 4'd7;

            man_a <= {1'b1, a[2:0]};
            man_b <= {1'b1, b[2:0]};
        end
    end

    AINeuronX_FP8_BOOTH_RECODE booth_u (
        .man_b(man_b),
        .booth_code(booth)
    );

    AINeuronX_FP8_PP_LUT lut_u (
        .man_a(man_a),
        .booth(booth),
        .pp(pp)
    );

    // Pack FP16 (simplificado, normalización siguiente fase)
    assign result_fp16 = {sign, exp_sum[4:0], pp[9:0]};

endmodule
