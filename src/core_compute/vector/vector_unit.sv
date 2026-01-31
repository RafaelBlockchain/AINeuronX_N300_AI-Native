`timescale 1ns/1ps

module vector_unit #(
    parameter int DATA_WIDTH = 16,
    parameter int LANES = 4
)(
    input  logic clk,
    input  logic rst_n,

    // Control
    input  logic        start,
    input  logic [1:0]  op,        // 00: ADD, 01: MUL, 10: MAC
    output logic        busy,
    output logic        done,

    // Vector inputs
    input  logic signed [DATA_WIDTH-1:0] vec_a [LANES-1:0],
    input  logic signed [DATA_WIDTH-1:0] vec_b [LANES-1:0],
    input  logic signed [DATA_WIDTH-1:0] vec_acc [LANES-1:0],

    // Vector output
    output logic signed [DATA_WIDTH-1:0] vec_out [LANES-1:0]
);

    logic signed [DATA_WIDTH-1:0] result [LANES-1:0];
    logic running;

    integer i;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            running <= 1'b0;
        end else begin
            if (start)
                running <= 1'b1;
            else
                running <= 1'b0;
        end
    end

    always_comb begin
        for (i = 0; i < LANES; i++) begin
            case (op)
                2'b00: result[i] = vec_a[i] + vec_b[i];                // ADD
                2'b01: result[i] = vec_a[i] * vec_b[i];                // MUL
                2'b10: result[i] = vec_acc[i] + vec_a[i] * vec_b[i];   // MAC
                default: result[i] = '0;
            endcase
        end
    end

    always_ff @(posedge clk) begin
        if (running) begin
            for (i = 0; i < LANES; i++)
                vec_out[i] <= result[i];
        end
    end

    assign busy = running;
    assign done = ~running;

endmodule
