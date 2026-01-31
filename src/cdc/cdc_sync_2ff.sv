module cdc_sync_2ff (
    input  logic clk_dst,
    input  logic rst_n,
    input  logic sig_src,
    output logic sig_dst
);
    logic ff1, ff2;

    always_ff @(posedge clk_dst or negedge rst_n) begin
        if (!rst_n) begin
            ff1 <= 0;
            ff2 <= 0;
        end else begin
            ff1 <= sig_src;
            ff2 <= ff1;
        end
    end

    assign sig_dst = ff2;
endmodule

