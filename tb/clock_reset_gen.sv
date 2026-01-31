//===========================================================
// Clock & Reset Generator
//===========================================================
module clock_reset_gen(
    output reg clk,
    output reg rst_n
);
    initial begin
        clk = 0;
        rst_n = 0;
        #20 rst_n = 1;
    end
    always #5 clk = ~clk; // 100 MHz
endmodule
