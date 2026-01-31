import json

class TraceMismatch(Exception):
    pass


class RTLComparator:
    def __init__(self, emulator_trace, rtl_trace):
        self.emu = self._load(emulator_trace)
        self.rtl = self._load(rtl_trace)

    def _load(self, path):
        with open(path, "r") as f:
            return json.load(f)

    def compare(self):
        min_len = min(len(self.emu), len(self.rtl))

        for i in range(min_len):
            e = self.emu[i]
            r = self.rtl[i]

            if e != r:
                raise TraceMismatch(
                    f"\n❌ MISMATCH @ index {i}\n"
                    f"EMULATOR: {e}\n"
                    f"RTL     : {r}"
                )

        if len(self.emu) != len(self.rtl):
            raise TraceMismatch(
                f"\n❌ TRACE LENGTH MISMATCH\n"
                f"EMULATOR: {len(self.emu)} events\n"
                f"RTL     : {len(self.rtl)} events"
            )

        print("✅ RTL == Emulator (Golden Match)")
