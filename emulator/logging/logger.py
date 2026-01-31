import json


class EventLogger:
    def __init__(self):
        self.events = []

    def log(self, event):
        self.events.append(event)

    def dump(self, path):
        with open(path, "w") as f:
            json.dump(self.events, f, indent=2)
