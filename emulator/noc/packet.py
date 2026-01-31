class NoCPacket:
    def __init__(self, src, dst, payload, created_cycle):
        self.src = src
        self.dst = dst
        self.payload = payload
        self.created = created_cycle
        self.hops = 0
