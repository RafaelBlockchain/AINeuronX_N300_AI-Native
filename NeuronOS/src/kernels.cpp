void launch_kernel(const Kernel& k) {
    // Solo dispara ejecución en tiles asignados
    for (auto tile : k.tiles) {
        program_tile(tile, k.binary);
    }
}
