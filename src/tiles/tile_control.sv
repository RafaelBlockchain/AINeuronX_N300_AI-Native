module tile_control(
  input  logic clk, rst,
  input  logic start,
  output logic busy,
  output logic done
);
  typedef enum logic [1:0] {IDLE, COMPUTE, DONE} state_t;
  state_t state;

  always_ff @(posedge clk or posedge rst) begin
    if (rst) state <= IDLE;
    else begin
      case (state)
        IDLE:     if (start) state <= COMPUTE;
        COMPUTE:  state <= DONE;
        DONE:     state <= IDLE;
      endcase
    end
  end

  assign busy = (state == COMPUTE);
  assign done = (state == DONE);
endmodule
