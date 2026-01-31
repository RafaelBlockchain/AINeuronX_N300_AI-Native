module scalar_unit (
    input  logic clk,
    input  logic reset,
    input  logic valid,
    output logic done
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            done <= 0;
        else
            done <= valid; // 1-cycle latency
    end
endmodule
