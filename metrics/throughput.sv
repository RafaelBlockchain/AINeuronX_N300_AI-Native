module throughput_meter(
  input logic clk,
  input logic valid
);
  integer count;
  integer cycles;

  always_ff @(posedge clk) begin
    cycles++;
    if (valid) count++;
    if (cycles == 1000) begin
      $display("THROUGHPUT: %0d flits / 1000 cycles", count);
      cycles = 0;
      count  = 0;
    end
  end
endmodule
