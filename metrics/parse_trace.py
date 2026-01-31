import json

def load_trace(path):
    with open(path) as f:
        return json.load(f)

def events_by_type(trace, event):
    return [e for e in trace if e["event"] == event]
