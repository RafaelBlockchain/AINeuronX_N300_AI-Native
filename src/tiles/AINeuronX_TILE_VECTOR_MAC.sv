module AINeuronX_TILE_VECTOR_MAC (
    input  logic clk,
    input  logic rst_n,
    input  logic valid,
    input  logic [7:0] vec_a [0:7],
    input  logic [7:0] vec_b [0:7],
    output logic [15:0] acc_out
);

    logic [15:0] acc;
    logic [15:0] mul_res [0:7];

    genvar i;
    generate
        for (i=0;i<8;i++) begin
            AINeuronX_FP8_MUL mul (
                .clk(clk),
                .rst_n(rst_n),
                .valid_in(valid),
                .a(vec_a[i]),
                .b(vec_b[i]),
                .valid_out(),
                .result_fp16(mul_res[i])
            );
        end
    endgenerate

    always_ff @(posedge clk) begin
        if (!rst_n)
            acc <= 0;
        else if (valid)
            acc <= acc + mul_res[0] + mul_res[1] + mul_res[2] +
                         mul_res[3] + mul_res[4] + mul_res[5] +
                         mul_res[6] + mul_res[7];
    end

    assign acc_out = acc;

endmodule
