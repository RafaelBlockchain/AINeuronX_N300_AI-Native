package ax_isa_defs;

    typedef enum logic [3:0] {
        DOMAIN_TENSOR  = 4'h0,
        DOMAIN_VECTOR  = 4'h1,
        DOMAIN_DMA     = 4'h2,
        DOMAIN_CTRL    = 4'hF
    } ax_domain_t;

    typedef enum logic [3:0] {
        // Tensor
        T_MMA   = 4'h0,
        T_LOAD  = 4'h1,
        T_STORE = 4'h2,
        T_SYNC  = 4'h3,

        // Vector
        V_ADD   = 4'h0,
        V_MUL   = 4'h1,
        V_LOAD  = 4'h2,

        // DMA
        D_COPY  = 4'h0,
        D_PREF  = 4'h1
    } ax_opcode_t;

endpackage
