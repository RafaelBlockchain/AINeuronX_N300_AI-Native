import ax_isa_defs::*;

typedef struct packed {
    ax_domain_t domain;     // [31:28]
    ax_opcode_t opcode;    // [27:24]
    logic [7:0] flags;     // [23:16]
    logic [15:0] operand;  // [15:0]
} ax_instr_t;
