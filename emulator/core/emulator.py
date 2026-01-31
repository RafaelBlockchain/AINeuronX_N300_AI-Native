from enum import Enum


class GlobalState(Enum):
    RUNNING = 0
    DONE = 1


class Emulator:
    def __init__(self, tiles, logger, max_cycles=1000):
        self.tiles = tiles
        self.logger = logger
        self.max_cycles = max_cycles

        self.cycle = 0
        self.state = GlobalState.RUNNING

    def step(self):
        for tile in self.tiles:
            tile.step(self.cycle)

        self.cycle += 1

        if all(tile.current is None for tile in self.tiles):
            self.state = GlobalState.DONE

    def run(self):
        while self.state == GlobalState.RUNNING and self.cycle < self.max_cycles:
            self.step()
