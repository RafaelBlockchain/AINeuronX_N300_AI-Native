module ax_command_queue #(
    parameter DEPTH = 8
)(
    input  logic clk,
    input  logic rst_n,

    input  logic        push,
    input  ax_instr_t   instr_in,

    input  logic        pop,
    output ax_instr_t   instr_out,

    output logic full,
    output logic empty
);

    ax_instr_t mem[DEPTH];
    logic [$clog2(DEPTH):0] wptr, rptr;

    assign full  = ((wptr + 1) == rptr);
    assign empty = (wptr == rptr);
    assign instr_out = mem[rptr[$clog2(DEPTH)-1:0]];

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wptr <= 0;
            rptr <= 0;
        end else begin
            if (push && !full) begin
                mem[wptr[$clog2(DEPTH)-1:0]] <= instr_in;
                wptr <= wptr + 1;
            end
            if (pop && !empty)
                rptr <= rptr + 1;
        end
    end

endmodule
