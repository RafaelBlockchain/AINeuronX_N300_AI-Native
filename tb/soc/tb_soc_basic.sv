module tb_soc_basic;
  logic clk=0, rst=1;

  always #5 clk = ~clk;

  soc_top dut (
    .clk(clk),
    .rst(rst)
  );

  initial begin
    #20 rst=0;
    #1000 $finish;
  end
endmodule
