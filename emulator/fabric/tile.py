class Tile:
    def __init__(self, tile_id):
        self.id = tile_id

    def execute(self, instr):
        # v0: solo log
        print(f"[Tile {self.id}] EXEC {instr.opcode}")
