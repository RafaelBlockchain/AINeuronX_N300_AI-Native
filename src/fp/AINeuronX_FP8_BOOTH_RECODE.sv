module AINeuronX_FP8_BOOTH_RECODE (
    input  logic [3:0] man_b,
    output logic signed [2:0] booth_code
);
    always_comb begin
        case (man_b)
            4'b0000: booth_code =  0;
            4'b0001: booth_code = +1;
            4'b0010: booth_code = +1;
            4'b0011: booth_code = +2;
            4'b0100: booth_code = +2;
            4'b0101: booth_code = -1;
            4'b0110: booth_code = -1;
            4'b0111: booth_code = -2;
            default: booth_code = 0;
        endcase
    end
endmodule
