class Router:
    def route(self, src_tile, dst_tile, instr):
        dst_tile.execute(instr)
