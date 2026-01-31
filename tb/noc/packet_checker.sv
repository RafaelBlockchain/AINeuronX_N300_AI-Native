module packet_checker #(parameter W=64)(
  input logic clk,
  input logic valid,
  input logic [W-1:0] data
);
  logic [W-1:0] last;

  always_ff @(posedge clk) begin
    if (valid) begin
      if (data !== last + 1 && last !== '0)
        $error("PACKET ERROR: expected %0d got %0d", last+1, data);
      last <= data;
    end
  end
endmodule
