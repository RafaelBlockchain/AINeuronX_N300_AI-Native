//===========================================================
// Error Injection (RTL inicial)
// Introduce errores para pruebas de resiliencia
//===========================================================
`timescale 1ns/1ps
module error_injection #(
    parameter DATA_WIDTH = 16
)(
    input  wire clk,
    input  wire rst_n,
    input  wire [DATA_WIDTH-1:0] data_in,
    input  wire inject_error,
    output reg  [DATA_WIDTH-1:0] data_out
);
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) data_out <= 0;
        else if(inject_error) data_out <= data_in ^ 16'hFFFF;
        else data_out <= data_in;
    end
endmodule

