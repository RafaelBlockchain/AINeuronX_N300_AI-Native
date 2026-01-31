class NoC:
    def __init__(self, tiles):
        self.tiles = tiles
        self.idx = 0

    def next_tile(self):
        tile = self.tiles[self.idx]
        self.idx = (self.idx + 1) % len(self.tiles)
        return tile
