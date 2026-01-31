module vector_core_top (
    input  logic clk,
    input  logic rst_n,

    input  logic        valid_in,
    input  logic [1:0]  opcode,   // 00=ADD, 01=MUL, 10=LOAD
    input  logic [31:0] src_a,
    input  logic [31:0] src_b,

    output logic        valid_out,
    output logic [31:0] result
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 0;
            result    <= 0;
        end else begin
            valid_out <= valid_in;
            case (opcode)
                2'b00: result <= src_a + src_b;
                2'b01: result <= src_a * src_b;
                2'b10: result <= src_a;
                default: result <= 0;
            endcase
        end
    end

endmodule
