module latency_meter #(parameter W=64)(
  input logic clk,
  input logic in_valid,
  input logic out_valid
);
  integer start_cycle;
  integer cycle;

  always_ff @(posedge clk) cycle++;

  always_ff @(posedge clk) begin
    if (in_valid)
      start_cycle <= cycle;
    if (out_valid)
      $display("LATENCY: %0d cycles", cycle - start_cycle);
  end
endmodule
