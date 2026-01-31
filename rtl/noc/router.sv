module router #(
    parameter DEPTH = 4
)(
    input  logic clk,
    input  logic reset,
    input  logic in_valid,
    output logic in_ready,
    output logic out_valid
);
    integer count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            count <= 0;
        else begin
            if (in_valid && in_ready)
                count <= count + 1;
            if (out_valid && count > 0)
                count <= count - 1;
        end
    end

    assign in_ready  = (count < DEPTH);
    assign out_valid = (count > 0);
endmodule
