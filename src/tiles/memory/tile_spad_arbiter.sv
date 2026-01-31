`timescale 1ns/1ps

module tile_spad_arbiter (
    input  logic clk,
    input  logic rst_n,

    input  logic [2:0] req,
    output logic [2:0] grant
);

    logic [1:0] last;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            last <= 2'd0;
        else if (|grant)
            last <= grant[0] ? 2'd0 :
                    grant[1] ? 2'd1 : 2'd2;
    end

    always_comb begin
        grant = 3'b000;
        for (int i = 1; i <= 3; i++) begin
            int idx = (last + i) % 3;
            if (req[idx]) begin
                grant[idx] = 1'b1;
                break;
            end
        end
    end

endmodule
