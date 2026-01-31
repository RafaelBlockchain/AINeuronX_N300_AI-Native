module tile_core_compute #(parameter W=64)(
  input  logic clk,
  input  logic enable,
  input  logic [W-1:0] in_data,
  output logic [W-1:0] out_data
);
  always_ff @(posedge clk) begin
    if (enable)
      out_data <= in_data + 1;
  end
endmodule
