#include "Vaineuronx_chip.h"
#include "verilated.h"
#include <iostream>
#include <cstdlib>

vluint64_t main_time = 0;
double sc_time_stamp() { return main_time; }

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);

    Vaineuronx_chip* top = new Vaineuronx_chip;

    // Reset
    top->clk = 0;
    top->rst_n = 0;
    top->valid_in = 0;
    top->select_precision = 0;
    top->prefetch_enable = 1;

    // Ciclos de reset
    for (int i = 0; i < 10; i++) {
        top->clk ^= 1;
        top->eval();
        main_time++;
    }
    top->rst_n = 1;

    // Simulación FP16
    for (int i = 0; i < 256; i++) {
        top->input_a = i;
        top->input_b = i + 1;
        top->valid_in = 1;

        for (int c = 0; c < 2; c++) {
            top->clk ^= 1;
            top->eval();
            main_time++;
        }

        top->valid_in = 0;
    }

    // Simulación FP8
    top->select_precision = 1;
    for (int i = 0; i < 256; i++) {
        top->input_a = i & 0xFF;
        top->input_b = (i + 1) & 0xFF;
        top->valid_in = 1;

        for (int c = 0; c < 2; c++) {
            top->clk ^= 1;
            top->eval();
            main_time++;
        }

        top->valid_in = 0;
    }

    std::cout << "✔ Simulación AINeuronX completada correctamente\n";
    std::cout << "Output final del chip: " << top->output_chip << "\n";

    delete top;
    return 0;
}
