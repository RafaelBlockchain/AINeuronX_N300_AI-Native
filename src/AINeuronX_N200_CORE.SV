`timescale 1ns/1ps

module AINeuronX_N200_CORE #(
    parameter int DATA_WIDTH   = 16,
    parameter int VECTOR_LANES = 4
)(
    input  logic clk,
    input  logic rst_n,
    input  logic valid_in,
    input  logic prefetch_enable,
    input  logic [DATA_WIDTH*VECTOR_LANES-1:0] input_a,
    input  logic [DATA_WIDTH*VECTOR_LANES-1:0] input_b,
    output logic ready_out,
    output logic [DATA_WIDTH*VECTOR_LANES-1:0] output_data
);

    logic valid_d;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            valid_d    <= 1'b0;
            ready_out  <= 1'b0;
            output_data <= '0;
        end else begin
            valid_d   <= valid_in && prefetch_enable;
            ready_out <= valid_d;

            if (valid_d) begin
                for (int l = 0; l < VECTOR_LANES; l++) begin
                    output_data[l*DATA_WIDTH +: DATA_WIDTH]
                        <= input_a[l*DATA_WIDTH +: DATA_WIDTH]
                         + input_b[l*DATA_WIDTH +: DATA_WIDTH];
                end
            end
        end
    end

endmodule
