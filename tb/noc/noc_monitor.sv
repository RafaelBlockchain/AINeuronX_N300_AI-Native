module noc_monitor(
  input logic clk,
  input logic activity
);
  integer cycles;

  always_ff @(posedge clk) begin
    cycles++;
    if (activity)
      $display("NoC activity at cycle %0d", cycles);
  end
endmodule
