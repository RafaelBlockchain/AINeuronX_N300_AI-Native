module clock_domain_ctrl (
    input  logic clk_in,
    input  logic enable,
    output logic clk_out
);

    always_ff @(posedge clk_in) begin
        clk_out <= enable ? clk_in : 1'b0;
    end

endmodule
