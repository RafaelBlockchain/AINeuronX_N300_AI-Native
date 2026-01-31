class DMARequest:
    def __init__(self, tile_id, buffer_id, size, latency):
        self.tile_id = tile_id
        self.buffer_id = buffer_id
        self.size = size
        self.remaining = latency
        self.done = False


class DMAEngine:
    def __init__(self):
        self.active = []
        self.completed = []

    def start(self, req: DMARequest):
        self.active.append(req)

    def step(self):
        for req in list(self.active):
            req.remaining -= 1
            if req.remaining <= 0:
                req.done = True
                self.active.remove(req)
                self.completed.append(req)

    def is_done(self, tile_id):
        return any(r.tile_id == tile_id for r in self.completed)

    def clear_done(self, tile_id):
        self.completed = [r for r in self.completed if r.tile_id != tile_id]
