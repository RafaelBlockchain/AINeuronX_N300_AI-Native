module ax_completion_fifo (
    input  logic clk,
    input  logic rst_n,

    input  logic done_in,
    output logic done_out
);

    logic flag;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            flag <= 0;
        else if (done_in)
            flag <= 1;
        else
            flag <= 0;
    end

    assign done_out = flag;

endmodule
