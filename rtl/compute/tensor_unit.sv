module tensor_unit #(
    parameter LAT = 16
)(
    input  logic clk,
    input  logic reset,
    input  logic valid,
    output logic done
);
    integer cnt;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            cnt  <= 0;
            done <= 0;
        end else begin
            if (valid && cnt == 0)
                cnt <= LAT;
            else if (cnt > 0)
                cnt <= cnt - 1;

            done <= (cnt == 1);
        end
    end
endmodule
