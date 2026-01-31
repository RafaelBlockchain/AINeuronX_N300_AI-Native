module tb_system_top;
  logic clk = 0;
  logic rst_n = 0;

  always #5 clk = ~clk;

  aineuronx_top dut (.clk(clk), .rst_n(rst_n));

  initial begin
    #50 rst_n = 1;
    #100;
    `include "../scenarios/sc_basic_boot.sv"
    #200;
    $finish;
  end
endmodule
