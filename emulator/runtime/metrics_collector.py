class TileMetrics:
    def __init__(self, tile_id):
        self.tile_id = tile_id
        self.instr = 0
        self.route = 0
        self.stall = 0

    def update(self, pkt):
        _, self.instr, self.route, self.stall = pkt


class MetricsCollector:
    def __init__(self):
        self.tiles = {}

    def ingest(self, pkt):
        tile_id = pkt[0]
        if tile_id not in self.tiles:
            self.tiles[tile_id] = TileMetrics(tile_id)
        self.tiles[tile_id].update(pkt)

    def snapshot(self):
        return self.tiles
