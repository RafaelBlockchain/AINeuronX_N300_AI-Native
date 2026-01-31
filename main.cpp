// main.cpp
#include "Vaineuronx_tb_vector.h"
int main(int argc, char **argv, char **env) {
    Vaineuronx_tb_vector* top = new Vaineuronx_tb_vector;
    while (!Verilated::gotFinish()) {
        top->eval();
    }
    delete top;
    return 0;
}
