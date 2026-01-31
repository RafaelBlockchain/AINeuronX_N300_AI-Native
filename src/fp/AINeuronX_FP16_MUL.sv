module AINeuronX_FP16_MUL (
    input  logic clk,
    input  logic rst_n,
    input  logic valid_in,

    input  logic [15:0] a,
    input  logic [15:0] b,

    output logic valid_out,
    output logic [15:0] result
);

    // ===== Decode =====
    logic sign_a, sign_b;
    logic [4:0] exp_a, exp_b;
    logic [10:0] man_a, man_b;

    logic sign_p;
    logic [6:0] exp_p;
    logic [21:0] man_p;

    always_ff @(posedge clk) begin
        if (valid_in) begin
            sign_a <= a[15];
            sign_b <= b[15];
            exp_a  <= a[14:10];
            exp_b  <= b[14:10];
            man_a  <= {1'b1, a[9:0]};
            man_b  <= {1'b1, b[9:0]};
        end
    end

    // ===== Multiply mantissas (INTEGER MUL) =====
    always_ff @(posedge clk) begin
        sign_p <= sign_a ^ sign_b;
        exp_p  <= exp_a + exp_b - 5'd15;
        man_p  <= man_a * man_b;   // ← entero, NO FP
    end

    // ===== Normalize =====
    always_ff @(posedge clk) begin
        if (man_p[21]) begin
            result <= {sign_p, exp_p + 1'b1, man_p[20:11]};
        end else begin
            result <= {sign_p, exp_p, man_p[19:10]};
        end
    end

    // ===== Valid pipeline =====
    logic [2:0] vld;
    always_ff @(posedge clk) begin
        if (!rst_n)
            vld <= 0;
        else begin
            vld[0] <= valid_in;
            vld[1] <= vld[0];
            vld[2] <= vld[1];
        end
    end

    assign valid_out = vld[2];

endmodule
