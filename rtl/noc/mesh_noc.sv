module mesh_noc (
    input logic clk,
    input logic reset,
    input logic send,
    output logic recv
);
    // Simplified single-hop placeholder
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            recv <= 0;
        else
            recv <= send;
    end
endmodule
