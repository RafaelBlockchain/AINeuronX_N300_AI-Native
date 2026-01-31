module noc_vc_buffer_2flit #(
    parameter int FLIT_W = 128
)(
    input  logic clk,
    input  logic rst_n,

    input  logic              in_valid,
    output logic              in_ready,
    input  logic [FLIT_W-1:0] in_flit,

    output logic              out_valid,
    input  logic              out_ready,
    output logic [FLIT_W-1:0] out_flit
);

    logic [FLIT_W-1:0] fifo[1:0];
    logic [1:0] wr_ptr, rd_ptr;
    logic [2:0] count;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count  <= 0;
        end else begin
            if (in_valid && in_ready) begin
                fifo[wr_ptr] <= in_flit;
                wr_ptr <= wr_ptr + 1;
                count  <= count + 1;
            end
            if (out_valid && out_ready) begin
                rd_ptr <= rd_ptr + 1;
                count  <= count - 1;
            end
        end
    end

    assign in_ready  = (count < 2);
    assign out_valid = (count > 0);
    assign out_flit  = fifo[rd_ptr];

endmodule

