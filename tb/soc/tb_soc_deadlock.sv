module tb_soc_deadlock;
  logic clk=0, rst=1;
  integer cycle_count;

  always #5 clk = ~clk;

  soc_top dut(.clk(clk), .rst(rst));

  initial begin
    cycle_count = 0;
    #20 rst = 0;
    repeat (2000) begin
      @(posedge clk);
      cycle_count++;
    end
    $display("NO DEADLOCK DETECTED (%0d cycles)", cycle_count);
    $finish;
  end
endmodule
