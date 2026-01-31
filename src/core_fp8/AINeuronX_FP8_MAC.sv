// ====================================================================
// AINeuronX_FP8_MAC
// Stage0: FP8 Decode (E4M3 / E5M2)
// ====================================================================
module AINeuronX_FP8_MAC #(
    parameter MODE = 0 // 0=E4M3, 1=E5M2
)(
    input  logic clk,
    input  logic rst_n,

    input  logic        in_valid,
    input  logic [7:0]  a_fp8,
    input  logic [7:0]  b_fp8,
    output logic        in_ready,

    output logic        out_valid,
    output logic [15:0] acc_fp16,

    input  logic        clear_acc
);

    // --------------------------------------------------
    // Señales Stage0 Decode
    // --------------------------------------------------
    logic        v0;

    logic        sign_a_0, sign_b_0;
    logic signed [6:0] exp_a_0, exp_b_0; // exponente des-bias
    logic [5:0]  mant_a_0, mant_b_0;     // 1.xxxxx
    logic        zero_a_0, zero_b_0;

    localparam int E4M3_BIAS = 7;
    localparam int E5M2_BIAS = 15;

    // --------------------------------------------------
    // Stage0 Decode FP8
    // --------------------------------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            v0        <= 1'b0;
            sign_a_0  <= 1'b0;
            sign_b_0  <= 1'b0;
            exp_a_0   <= 7'sd0;
            exp_b_0   <= 7'sd0;
            mant_a_0  <= 6'd0;
            mant_b_0  <= 6'd0;
            zero_a_0  <= 1'b1;
            zero_b_0  <= 1'b1;
        end else begin
            v0 <= in_valid;

            if (in_valid) begin
                // Signos
                sign_a_0 <= a_fp8[7];
                sign_b_0 <= b_fp8[7];

                // Decodificación por modo
                if (MODE == 0) begin
                    // =====================
                    // FP8 E4M3
                    // [7] sign, [6:3] exp, [2:0] mant
                    // =====================
                    zero_a_0 <= (a_fp8[6:0] == 7'd0);
                    zero_b_0 <= (b_fp8[6:0] == 7'd0);

                    exp_a_0  <= (a_fp8[6:0] == 0) ? 7'sd0 : $signed({1'b0, a_fp8[6:3]}) - 7'sdE4M3_BIAS;
                    mant_a_0 <= (a_fp8[6:0] == 0) ? 6'd0 : {1'b1, a_fp8[2:0], 2'b00};

                    exp_b_0  <= (b_fp8[6:0] == 0) ? 7'sd0 : $signed({1'b0, b_fp8[6:3]}) - 7'sdE4M3_BIAS;
                    mant_b_0 <= (b_fp8[6:0] == 0) ? 6'd0 : {1'b1, b_fp8[2:0], 2'b00};

                end else begin
                    // =====================
                    // FP8 E5M2
                    // [7] sign, [6:2] exp, [1:0] mant
                    // =====================
                    zero_a_0 <= (a_fp8[6:0] == 7'd0);
                    zero_b_0 <= (b_fp8[6:0] == 7'd0);

                    exp_a_0  <= (a_fp8[6:0] == 0) ? 7'sd0 : $signed({1'b0, a_fp8[6:2]}) - 7'sdE5M2_BIAS;
                    mant_a_0 <= (a_fp8[6:0] == 0) ? 6'd0 : {1'b1, a_fp8[1:0], 3'b000};

                    exp_b_0  <= (b_fp8[6:0] == 0) ? 7'sd0 : $signed({1'b0, b_fp8[6:2]}) - 7'sdE5M2_BIAS;
                    mant_b_0 <= (b_fp8[6:0] == 0) ? 6'd0 : {1'b1, b_fp8[1:0], 3'b000};
                end
            end
        end
    end

    // --------------------------------------------------
    // Output Stage0
    // --------------------------------------------------
    assign out_valid = v0;
    assign in_ready  = 1'b1;

    // Para Stage0, acumulador queda en cero
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) acc_fp16 <= 16'd0;
        else if (clear_acc) acc_fp16 <= 16'd0;
    end

endmodule
