module vector_top (
    input logic clk,
    input logic rst_n,
    input logic vec_valid,
    output logic vec_ready,
    output logic vec_done
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            vec_done <= 0;
        else if (vec_valid)
            vec_done <= 1;
        else
            vec_done <= 0;
    end

    assign vec_ready = 1'b1;

endmodule

