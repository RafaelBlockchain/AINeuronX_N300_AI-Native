module AINeuronX_FP8_MUL #(
    parameter MODE = 0  // 0 = E4M3, 1 = E5M2
)(
    input  logic clk,
    input  logic rst_n,
    input  logic valid_in,
    input  logic [7:0] a,
    input  logic [7:0] b,
    output logic valid_out,
    output logic [7:0] result
);

    logic sign;
    logic [6:0] exp;
    logic [7:0] man;

    always_ff @(posedge clk) begin
        if (valid_in) begin
            sign <= a[7] ^ b[7];

            if (MODE == 0) begin // E4M3
                exp <= a[6:3] + b[6:3] - 4'd7;
                man <= {1'b1, a[2:0]} * {1'b1, b[2:0]};
            end else begin // E5M2
                exp <= a[6:2] + b[6:2] - 5'd15;
                man <= {1'b1, a[1:0]} * {1'b1, b[1:0]};
            end
        end
    end

    always_ff @(posedge clk) begin
        result <= {sign, exp[4:0], man[4:0]};
    end

    assign valid_out = valid_in;

endmodule
