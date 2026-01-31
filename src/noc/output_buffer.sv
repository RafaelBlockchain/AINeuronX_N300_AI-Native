module output_buffer #(parameter W=64)(
  input  logic clk, rst,
  input  logic in_valid,
  input  logic [W-1:0] in_data,
  output logic in_ready,
  output logic out_valid,
  output logic [W-1:0] out_data,
  input  logic out_ready
);
  logic full;

  assign in_ready  = !full;
  assign out_valid = full;
  assign out_data  = in_data;

  always_ff @(posedge clk or posedge rst) begin
    if (rst) full <= 0;
    else begin
      if (in_valid && in_ready) full <= 1;
      if (out_valid && out_ready) full <= 0;
    end
  end
endmodule
