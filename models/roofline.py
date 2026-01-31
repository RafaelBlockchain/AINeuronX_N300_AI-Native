class RooflineModel:
    def __init__(
        self,
        peak_tops,
        mem_bw_gbs
    ):
        self.peak_tops = peak_tops
        self.mem_bw_gbs = mem_bw_gbs

    def arithmetic_intensity(self, flops, bytes_moved):
        return flops / bytes_moved

    def attainable_tops(self, intensity):
        bw_limited = intensity * self.mem_bw_gbs / 1e3
        return min(self.peak_tops, bw_limited)

    def point(self, flops, bytes_moved):
        intensity = self.arithmetic_intensity(flops, bytes_moved)
        tops = self.attainable_tops(intensity)
        return {
            "intensity": intensity,
            "attainable_TOPS": tops
        }
