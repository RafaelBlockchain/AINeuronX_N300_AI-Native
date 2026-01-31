module isa_decoder (
    input  logic [31:0] instr,
    output logic [5:0]  opcode,
    output logic [3:0]  class,
    output logic [3:0]  dst,
    output logic [3:0]  src0,
    output logic [3:0]  src1,
    output logic [7:0]  imm
);
    assign opcode = instr[31:26];
    assign class  = instr[25:22];
    assign dst    = instr[21:18];
    assign src0   = instr[17:14];
    assign src1   = instr[13:10];
    assign imm    = instr[7:0];
endmodule
