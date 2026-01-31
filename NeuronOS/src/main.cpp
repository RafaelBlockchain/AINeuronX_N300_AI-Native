int main() {
    Runtime rt;

    if (!rt.hardware_contract_ok()) {
        panic("Hardware does not satisfy N200 contract");
    }

    rt.run();
    return 0;
}

