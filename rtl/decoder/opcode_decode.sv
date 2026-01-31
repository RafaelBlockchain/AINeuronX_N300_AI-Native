module opcode_decode (
    input  logic [5:0] opcode,
    input  logic [3:0] class,
    output logic is_scalar,
    output logic is_vector,
    output logic is_tensor,
    output logic is_dma,
    output logic illegal
);
    always_comb begin
        is_scalar = 0;
        is_vector = 0;
        is_tensor = 0;
        is_dma    = 0;
        illegal   = 0;

        case (class)
            4'b0000: is_scalar = 1;
            4'b0001: is_vector = 1;
            4'b0010: is_tensor = 1;
            4'b0011: is_dma    = 1;
            default: illegal  = 1;
        endcase
    end
endmodule
