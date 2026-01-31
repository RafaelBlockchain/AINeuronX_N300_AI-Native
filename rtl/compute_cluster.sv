//===========================================================
// AINeuronX Compute Cluster (RTL integrado)
//===========================================================
`timescale 1ns/1ps
module compute_cluster #(
    parameter SUB_ARRAYS = 8,
    parameter CORES_PER_SUBARRAY = 64,
    parameter DATA_WIDTH_FP8 = 8,
    parameter DATA_WIDTH_FP16 = 16,
    parameter CACHE_SIZE = 1024
)(
    input  wire clk,
    input  wire rst_n,
    input  wire [DATA_WIDTH_FP16-1:0] input_a,
    input  wire [DATA_WIDTH_FP16-1:0] input_b,
    input  wire select_precision,
    input  wire valid_in,
    input  wire prefetch_enable,
    output wire [DATA_WIDTH_FP16-1:0] output_c,
    output wire ready_out
);

    // =======================================================
    // Tensor Core Array
    // =======================================================
    wire [DATA_WIDTH_FP16-1:0] tca_out;
    wire tca_ready;

    tensor_core_array #(
        .SUB_ARRAYS(SUB_ARRAYS),
        .CORES_PER_SUBARRAY(CORES_PER_SUBARRAY),
        .DATA_WIDTH_FP8(DATA_WIDTH_FP8),
        .DATA_WIDTH_FP16(DATA_WIDTH_FP16)
    ) tca (
        .clk(clk),
        .rst_n(rst_n),
        .input_a(input_a),
        .input_b(input_b),
        .select_precision(select_precision),
        .valid_in(valid_in),
        .output_c(tca_out),
        .ready_out(tca_ready)
    );

    // =======================================================
    // L1 Caches (modelo de control / latencia)
    // =======================================================
    wire [SUB_ARRAYS-1:0] l1_ready;

    genvar i;
    generate
        for (i = 0; i < SUB_ARRAYS; i = i + 1) begin : L1_CACHES
            l1_cache_adaptive #(
                .CACHE_SIZE(CACHE_SIZE),
                .DATA_WIDTH(DATA_WIDTH_FP16)
            ) l1 (
                .clk(clk),
                .rst_n(rst_n),
                .data_in(input_a),
                .addr(i),
                .read_en(valid_in),
                .write_en(1'b0),
                .prefetch_enable(prefetch_enable),
                .ready_out(l1_ready[i])
            );
        end
    endgenerate

    // =======================================================
    // Reducción segura de ready (Verilator-safe)
    // =======================================================
    reg l1_ready_acc;
    integer k;

    always @(*) begin
        l1_ready_acc = 1'b1;
        for (k = 0; k < SUB_ARRAYS; k = k + 1) begin
            l1_ready_acc = l1_ready_acc & l1_ready[k];
        end
    end

    // =======================================================
    // Salidas finales
    // =======================================================
    assign output_c = tca_out;
    assign ready_out = tca_ready & l1_ready_acc;

endmodule
