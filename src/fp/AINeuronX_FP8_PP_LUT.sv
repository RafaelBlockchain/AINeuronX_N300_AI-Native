module AINeuronX_FP8_PP_LUT (
    input  logic [3:0] man_a,
    input  logic signed [2:0] booth,
    output logic signed [7:0] pp
);
    always_comb begin
        case (booth)
            0:  pp = 0;
            1:  pp =  man_a;
           -1:  pp = -man_a;
            2:  pp =  man_a << 1;
           -2:  pp = -(man_a << 1);
            default: pp = 0;
        endcase
    end
endmodule
