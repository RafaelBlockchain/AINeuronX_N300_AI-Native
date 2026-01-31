module AINeuronX_LOCAL_ARB (
    input  logic clk,
    input  logic rst_n,
    input  logic [3:0] req,
    output logic [3:0] grant
);

    always_ff @(posedge clk) begin
        if (!rst_n)
            grant <= 4'b0000;
        else if (req[0]) grant <= 4'b0001;
        else if (req[1]) grant <= 4'b0010;
        else if (req[2]) grant <= 4'b0100;
        else if (req[3]) grant <= 4'b1000;
    end

endmodule
