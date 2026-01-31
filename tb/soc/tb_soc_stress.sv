module tb_soc_stress;
  logic clk=0, rst=1;

  always #2 clk = ~clk;

  soc_top dut(.clk(clk), .rst(rst));

  initial begin
    #20 rst = 0;
    #5000 $display("TB_STRESS COMPLETED");
    #10 $finish;
  end
endmodule
