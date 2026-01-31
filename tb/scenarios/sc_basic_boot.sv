$display("SC_BASIC_BOOT");

for (int i = 0; i < dut.NUM_TILES; i++) begin
  if (dut.TC_STATUS[i] !== tile_if_pkg::TILE_IDLE)
    $fatal("Tile %0d not IDLE", i);
end

$display("SC_BASIC_BOOT PASS");
