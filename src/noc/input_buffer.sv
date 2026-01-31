module input_buffer #(parameter W=64, D=4)(
  input  logic clk, rst,
  input  logic in_valid,
  input  logic [W-1:0] in_data,
  output logic in_ready,
  output logic out_valid,
  output logic [W-1:0] out_data,
  input  logic out_ready
);
  logic [W-1:0] mem[D];
  logic [$clog2(D):0] rd, wr, cnt;

  assign in_ready  = (cnt < D);
  assign out_valid = (cnt > 0);
  assign out_data  = mem[rd];

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      rd <= 0; wr <= 0; cnt <= 0;
    end else begin
      if (in_valid && in_ready) begin
        mem[wr] <= in_data;
        wr <= wr + 1;
        cnt <= cnt + 1;
      end
      if (out_valid && out_ready) begin
        rd <= rd + 1;
        cnt <= cnt - 1;
      end
    end
  end
endmodule
