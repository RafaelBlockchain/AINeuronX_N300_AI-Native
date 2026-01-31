`timescale 1ns/1ps

module AINeuronX_ARRAY_2x2_TB;

  parameter DW = 16;

  logic clk;
  logic rst_n;
  logic in_valid;
  logic [DW-1:0] a [0:3];
  logic [DW-1:0] b [0:3];
  logic out_valid;
  logic [DW-1:0] result [0:3];

  // Clock
  initial clk = 0;
  always #5 clk = ~clk;

  // Instancia del ARRAY 2x2
  AINeuronX_ARRAY_2x2 dut (
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
    .a(a),
    .b(b),
    .out_valid(out_valid),
    .result(result)
  );

  // Testbench principal
  initial begin
    rst_n = 0;
    in_valid = 0;
    a = '{0,0,0,0};
    b = '{0,0,0,0};

    @(posedge clk);
    @(posedge clk);
    rst_n = 1;
    @(posedge clk);

    // Enviar estímulos
    a = '{1,3,5,7};
    b = '{2,4,6,8};
    in_valid = 1;
    @(posedge clk);
    in_valid = 0;

    // Esperar salida válida
    while (!out_valid) @(posedge clk);

    $display("ARRAY RESULTS:");
    $display("%0d %0d %0d %0d", result[0], result[1], result[2], result[3]);

    @(posedge clk);
    $finish;
  end

endmodule
