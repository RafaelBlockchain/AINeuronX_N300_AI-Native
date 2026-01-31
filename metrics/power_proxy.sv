module power_proxy(
  input logic clk,
  input logic signal_in
);
  integer toggles;
  logic prev;

  always_ff @(posedge clk) begin
    if (signal_in ^ prev)
      toggles++;
    prev <= signal_in;
  end

  final begin
    $display("POWER PROXY: %0d toggles", toggles);
  end
endmodule

