//===========================================================
// Sub-array module: 64 Tensor Cores
// Simple multiply-accumulate pipeline
//===========================================================
`timescale 1ns/1ps
module tensor_subarray #(
    parameter CORES = 64,
    parameter DATA_WIDTH_FP8 = 8,
    parameter DATA_WIDTH_FP16 = 16
)(
    input  wire clk,
    input  wire rst_n,
    input  wire [DATA_WIDTH_FP16-1:0] input_a,
    input  wire [DATA_WIDTH_FP16-1:0] input_b,
    input  wire select_precision,
    input  wire valid_in,
    output reg  [DATA_WIDTH_FP16-1:0] output_c,
    output reg  ready_out
);
    integer k;
    reg [DATA_WIDTH_FP16-1:0] core_accum [CORES-1:0];

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            output_c <= 0;
            ready_out <= 0;
            for(k=0; k<CORES; k=k+1)
                core_accum[k] <= 0;
        end else if(valid_in) begin
            for(k=0; k<CORES; k=k+1) begin
                if(select_precision) begin
                    core_accum[k] <= core_accum[k] + (input_a[DATA_WIDTH_FP8-1:0] * input_b[DATA_WIDTH_FP8-1:0]);
                end else begin
                    core_accum[k] <= core_accum[k] + (input_a * input_b);
                end
            end
            output_c <= core_accum[0] + core_accum[1] + core_accum[2];
            ready_out <= 1;
        end else begin
            ready_out <= 0;
        end
    end
endmodule

