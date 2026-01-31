module trace_export (
    input logic clk,
    input logic valid,
    input logic [5:0] opcode,
    input logic [31:0] cycle
);
    always_ff @(posedge clk) begin
        if (valid) begin
            $display("{\"cycle\":%0d,\"event\":\"COMMIT\",\"opcode\":%0d}",
                     cycle, opcode);
        end
    end
endmodule
