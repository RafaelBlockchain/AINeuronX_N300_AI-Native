//===========================================================
// Testbench completo AINeuronX
// Integración de todos los módulos RTL
//===========================================================
`timescale 1ns/1ps

module tb_aineuronx_full();

    parameter DATA_WIDTH_FP16 = 16;
    parameter DATA_WIDTH_FP8  = 8;
    parameter MATRIX_SIZE = 64;
    parameter NUM_CLUSTERS = 8;

    // Señales principales
    wire clk;
    wire rst_n;

    // Generador de clock y reset
    clock_reset_gen clk_rst_inst (
        .clk(clk),
        .rst_n(rst_n)
    );

    // Entradas de datos simuladas
    reg [DATA_WIDTH_FP16-1:0] input_a;
    reg [DATA_WIDTH_FP16-1:0] input_b;
    reg select_precision;
    reg valid_in;
    reg prefetch_enable;
    reg inject_error;

    // Salidas del chip
    wire [DATA_WIDTH_FP16-1:0] output_chip;
    wire ready_chip;

    // Instanciación del chip completo
    aineuronx_chip chip_inst (
        .clk(clk),
        .rst_n(rst_n),
        .input_a(input_a),
        .input_b(input_b),
        .select_precision(select_precision),
        .valid_in(valid_in),
        .prefetch_enable(prefetch_enable),
        .output_chip(output_chip),
        .ready_chip(ready_chip)
    );

    // Instanciación de L2, DMA, crossbar, NVLink, power_model, error_injection
    wire [DATA_WIDTH_FP16-1:0] l2_out;
    wire l2_ready;
    wire dma_done;
    wire [31:0] power_watt;
    wire [DATA_WIDTH_FP16-1:0] error_out;

    l2_cache l2_inst (
        .clk(clk), .rst_n(rst_n),
        .data_in(input_a), .addr(0),
        .read_en(valid_in), .write_en(0),
        .data_out(l2_out), .ready_out(l2_ready)
    );

    memory_controller mem_ctrl_inst (
        .clk(clk), .rst_n(rst_n),
        .read_req(valid_in), .write_req(0),
        .addr(0), .data_in(input_a),
        .data_out(), .ready()
    );

    dma_engine dma_inst (
        .clk(clk), .rst_n(rst_n),
        .start(valid_in),
        .mem_data_in(input_a),
        .mem_data_out(), .done(dma_done)
    );

    crossbar_network crossbar_inst (
        .clk(clk), .rst_n(rst_n),
        .data_in({NUM_CLUSTERS{input_a}}),
        .data_out()
    );

    nvlink_pcie_link link_inst (
        .clk(clk), .rst_n(rst_n),
        .data_in(input_a),
        .data_out(), .valid_out()
    );

    power_model power_inst (
        .clk(clk), .rst_n(rst_n),
        .active_clusters({NUM_CLUSTERS{1'b1}}),
        .power_watt(power_watt)
    );

    error_injection err_inst (
        .clk(clk), .rst_n(rst_n),
        .data_in(input_a),
        .inject_error(inject_error),
        .data_out(error_out)
    );

    // Matrices de prueba
    reg [DATA_WIDTH_FP16-1:0] matrix_a [0:MATRIX_SIZE-1][0:MATRIX_SIZE-1];
    reg [DATA_WIDTH_FP16-1:0] matrix_b [0:MATRIX_SIZE-1][0:MATRIX_SIZE-1];
    integer i,j;
    integer cycle_count;

    initial begin
        // Inicialización
        valid_in = 0; prefetch_enable = 1; select_precision = 0;
        inject_error = 0;
        cycle_count = 0;

        // Inicializar matrices
        for(i=0;i<MATRIX_SIZE;i=i+1) begin
            for(j=0;j<MATRIX_SIZE;j=j+1) begin
                matrix_a[i][j] = i*16 + j;
                matrix_b[i][j] = i*16 + j + 1;
            end
        end

        // Release reset
        #25;

        // Simulación FP16
        for(i=0;i<MATRIX_SIZE;i=i+1) begin
            for(j=0;j<MATRIX_SIZE;j=j+1) begin
                input_a = matrix_a[i][j];
                input_b = matrix_b[i][j];
                valid_in = 1; #10;
                valid_in = 0; #10;
                cycle_count = cycle_count + 2;
            end
        end

        // Simulación FP8
        select_precision = 1;
        for(i=0;i<MATRIX_SIZE;i=i+1) begin
            for(j=0;j<MATRIX_SIZE;j=j+1) begin
                input_a = matrix_a[i][j][DATA_WIDTH_FP8-1:0];
                input_b = matrix_b[i][j][DATA_WIDTH_FP8-1:0];
                valid_in = 1; #10;
                valid_in = 0; #10;
                cycle_count = cycle_count + 2;
            end
        end

        // Test error injection
        inject_error = 1; input_a = 16'h1234; #10; inject_error = 0;

        $display("Simulación completa. Ciclos: %0d", cycle_count);
        $display("Output chip: %0d, Power estimado: %0d W", output_chip, power_watt);
        $stop;
    end
endmodule

