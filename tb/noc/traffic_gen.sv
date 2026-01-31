module traffic_gen #(parameter W=64)(
  input  logic clk, rst,
  output logic valid,
  output logic [W-1:0] data,
  input  logic ready
);
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      valid <= 0;
      data  <= 0;
    end else begin
      valid <= 1;
      if (ready)
        data <= data + 1;
    end
  end
endmodule
