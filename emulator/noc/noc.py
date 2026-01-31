from emulator.noc.router import Router
from emulator.noc.packet import NoCPacket

class NoC:
    def __init__(self, width, height, hop_latency=1, logger=None):
        self.width = width
        self.height = height
        self.hop_latency = hop_latency
        self.logger = logger

        self.routers = {
            (x, y): Router(x, y)
            for x in range(width)
            for y in range(height)
        }

        self.in_flight = []  # (packet, remaining_latency, next_coord)

    def coord_of_tile(self, tile_id):
        x = tile_id % self.width
        y = tile_id // self.width
        return (x, y)

    def send(self, src_tile, dst_tile, payload, cycle):
        src = self.coord_of_tile(src_tile)
        dst = self.coord_of_tile(dst_tile)
        pkt = NoCPacket(src, dst, payload, cycle)

        router = self.routers[src]
        if not router.enqueue(pkt):
            return False  # backpressure

        if self.logger:
            self.logger.log(cycle, src_tile, "NOC_SEND", f"{src}->{dst}")
        return True

    def step(self, cycle):
        # mover paquetes router -> in_flight
        for coord, router in self.routers.items():
            pkt = router.dequeue()
            if pkt:
                next_coord = self._next_hop(coord, pkt.dst)
                pkt.hops += 1
                self.in_flight.append([pkt, self.hop_latency, next_coord])

        # avanzar paquetes en vuelo
        for entry in list(self.in_flight):
            entry[1] -= 1
            if entry[1] <= 0:
                pkt, _, next_coord = entry
                self.in_flight.remove(entry)

                if next_coord == pkt.dst:
                    if self.logger:
                        self.logger.log(cycle, None, "NOC_RECV", f"{pkt.dst}")
                else:
                    router = self.routers[next_coord]
                    if router.enqueue(pkt):
                        continue
                    else:
                        # backpressure: se queda en vuelo
                        self.in_flight.append([pkt, self.hop_latency, next_coord])

    def _next_hop(self, current, dst):
        cx, cy = current
        dx, dy = dst

        if cx < dx:
            return (cx + 1, cy)
        if cx > dx:
            return (cx - 1, cy)
        if cy < dy:
            return (cx, cy + 1)
        if cy > dy:
            return (cx, cy - 1)

        return current
