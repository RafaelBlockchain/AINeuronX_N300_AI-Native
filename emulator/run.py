from emulator.core.emulator import Emulator
from emulator.tile import Tile
from emulator.program.program import n300
from emulator.logging.logger import EventLogger
from emulator.memory.dma import DMAEngine


def main():
    logger = EventLogger()
    dma = DMAEngine()

    program = n300_workload()

    tiles = []
    ssb = None
    num_tiles = 1

    for i in range(num_tiles):
        tiles.append(
            Tile(
                tile_id=i,
                program=program,
                ssb=ssb,
                dma_engine=dma,
                logger=logger,
            )
        )

    emu = Emulator(tiles=tiles, logger=logger)
    emu.run()

    logger.dump("emu_trace.json")


if __name__ == "__main__":
    main()
