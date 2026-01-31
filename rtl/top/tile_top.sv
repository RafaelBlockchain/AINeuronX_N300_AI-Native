module tile_top (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] instr,
    input  logic        instr_valid,
    input  logic [31:0] cycle,

    output logic        stall
);

    /* ====== Decode ====== */
    logic [5:0] opcode;
    logic [3:0] class;
    logic [3:0] dst, src0, src1;
    logic [7:0] imm;

    isa_decoder u_decoder (
        .instr(instr),
        .opcode(opcode),
        .class(class),
        .dst(dst),
        .src0(src0),
        .src1(src1),
        .imm(imm)
    );

    logic is_scalar, is_vector, is_tensor, is_dma, illegal;

    opcode_decode u_opdecode (
        .opcode(opcode),
        .class(class),
        .is_scalar(is_scalar),
        .is_vector(is_vector),
        .is_tensor(is_tensor),
        .is_dma(is_dma),
        .illegal(illegal)
    );

    /* ====== Units ====== */
    logic done_scalar, done_vector, done_tensor, done_dma;

    scalar_unit u_scalar (
        .clk(clk),
        .reset(reset),
        .valid(instr_valid & is_scalar),
        .done(done_scalar)
    );

    vector_unit #(.LAT(4)) u_vector (
        .clk(clk),
        .reset(reset),
        .valid(instr_valid & is_vector),
        .done(done_vector)
    );

    tensor_unit #(.LAT(16)) u_tensor (
        .clk(clk),
        .reset(reset),
        .valid(instr_valid & is_tensor),
        .done(done_tensor)
    );

    dma_engine #(.LAT(8)) u_dma (
        .clk(clk),
        .reset(reset),
        .start(instr_valid & is_dma),
        .wait_req(1'b0),
        .done(done_dma)
    );

    /* ====== Scoreboard ====== */
    scoreboard u_scoreboard (
        .clk(clk),
        .reset(reset),
        .issue_scalar(instr_valid & is_scalar),
        .issue_vector(instr_valid & is_vector),
        .issue_tensor(instr_valid & is_tensor),
        .issue_dma(instr_valid & is_dma),
        .done_vector(done_vector),
        .done_tensor(done_tensor),
        .done_dma(done_dma),
        .stall(stall)
    );

    /* ====== Commit detect ====== */
    logic commit;
    assign commit = done_scalar | done_vector | done_tensor | done_dma;

    /* ====== Trace ====== */
    trace_export u_trace (
        .clk(clk),
        .valid(commit),
        .opcode(opcode),
        .cycle(cycle)
    );

endmodule
