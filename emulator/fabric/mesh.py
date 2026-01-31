from .tile import Tile
from .noc import NoC

class Mesh:
    def __init__(self, size):
        self.tiles = [Tile(i) for i in range(size)]
        self.noc = NoC(self.tiles)
