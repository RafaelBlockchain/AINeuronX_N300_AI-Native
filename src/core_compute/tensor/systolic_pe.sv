`timescale 1ns/1ps

module systolic_pe #(
    parameter int DATA_WIDTH = 16,
    parameter int ACC_WIDTH  = 32
)(
    input  logic clk,
    input  logic rst_n,

    // Control
    input  logic valid_in,
    input  logic clear_acc,

    // Systolic inputs
    input  logic signed [DATA_WIDTH-1:0] a_in,
    input  logic signed [DATA_WIDTH-1:0] b_in,

    // Systolic outputs
    output logic signed [DATA_WIDTH-1:0] a_out,
    output logic signed [DATA_WIDTH-1:0] b_out,

    // Accumulator output
    output logic signed [ACC_WIDTH-1:0] acc_out,
    output logic valid_out
);

    logic signed [ACC_WIDTH-1:0] acc_reg;
    logic signed [ACC_WIDTH-1:0] mul_result;

    assign mul_result = a_in * b_in;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc_reg   <= '0;
            a_out     <= '0;
            b_out     <= '0;
            valid_out <= 1'b0;
        end else begin
            a_out     <= a_in;
            b_out     <= b_in;
            valid_out <= valid_in;

            if (clear_acc) begin
                acc_reg <= '0;
            end else if (valid_in) begin
                acc_reg <= acc_reg + mul_result;
            end
        end
    end

    assign acc_out = acc_reg;

endmodule
