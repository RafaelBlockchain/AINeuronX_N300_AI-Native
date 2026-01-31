from collections import deque

class Router:
    def __init__(self, x, y, max_queue=4):
        self.x = x
        self.y = y
        self.queue = deque()
        self.max_queue = max_queue

    def can_accept(self):
        return len(self.queue) < self.max_queue

    def enqueue(self, packet):
        if not self.can_accept():
            return False
        self.queue.append(packet)
        return True

    def dequeue(self):
        if self.queue:
            return self.queue.popleft()
        return None
