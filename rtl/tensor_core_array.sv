//===========================================================
// AINeuronX Tensor Core Array (RTL)
// 512 Tensor Cores divididos en sub-arrays
//===========================================================
`timescale 1ns/1ps
module tensor_core_array #(
    parameter SUB_ARRAYS = 8,
    parameter CORES_PER_SUBARRAY = 64,
    parameter DATA_WIDTH_FP8 = 8,
    parameter DATA_WIDTH_FP16 = 16
)(
    input  wire clk,
    input  wire rst_n,
    input  wire [DATA_WIDTH_FP16-1:0] input_a,
    input  wire [DATA_WIDTH_FP16-1:0] input_b,
    input  wire select_precision,   // 0 = FP16, 1 = FP8
    input  wire valid_in,
    output wire [DATA_WIDTH_FP16-1:0] output_c,
    output wire ready_out
);

    // =======================================================
    // Subarray outputs
    // =======================================================
    wire [DATA_WIDTH_FP16-1:0] subarray_out [0:SUB_ARRAYS-1];
    wire                       sub_ready    [0:SUB_ARRAYS-1];

    // =======================================================
    // Instanciación de subarrays
    // =======================================================
    genvar gi;
    generate
        for (gi = 0; gi < SUB_ARRAYS; gi = gi + 1) begin : SUBARRAYS
            tensor_subarray #(
                .CORES(CORES_PER_SUBARRAY),
                .DATA_WIDTH_FP8(DATA_WIDTH_FP8),
                .DATA_WIDTH_FP16(DATA_WIDTH_FP16)
            ) subarray_inst (
                .clk(clk),
                .rst_n(rst_n),
                .input_a(input_a),
                .input_b(input_b),
                .select_precision(select_precision),
                .valid_in(valid_in),
                .output_c(subarray_out[gi]),
                .ready_out(sub_ready[gi])
            );
        end
    endgenerate

    // =======================================================
    // Reducción segura de ready (Verilator-safe)
    // =======================================================
    reg ready_acc;
    integer k;

    always @(*) begin
        ready_acc = 1'b1;
        for (k = 0; k < SUB_ARRAYS; k = k + 1) begin
            ready_acc = ready_acc & sub_ready[k];
        end
    end

    assign ready_out = ready_acc;

    // =======================================================
    // Agregación de resultados
    // =======================================================
    assign output_c =
          subarray_out[0] + subarray_out[1] + subarray_out[2] + subarray_out[3]
        + subarray_out[4] + subarray_out[5] + subarray_out[6] + subarray_out[7];

endmodule
