module dma_engine #(
    parameter LAT = 8
)(
    input  logic clk,
    input  logic reset,
    input  logic start,
    input  logic wait_req,
    output logic done
);
    integer cnt;
    logic active;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            cnt    <= 0;
            active <= 0;
            done   <= 0;
        end else begin
            if (start && !active) begin
                active <= 1;
                cnt    <= LAT;
            end

            if (active && cnt > 0)
                cnt <= cnt - 1;

            if (active && cnt == 1) begin
                active <= 0;
                done   <= 1;
            end else begin
                done <= 0;
            end
        end
    end
endmodule
