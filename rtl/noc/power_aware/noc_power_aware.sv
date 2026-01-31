module noc_power_aware (
    input  logic clk,
    input  logic traffic,
    output logic active
);

    always_ff @(posedge clk) begin
        active <= traffic;
    end

endmodule
