class IROp:
    def __init__(self, opcode, args):
        self.opcode = opcode    # ISA enum
        self.args = args        # explícitos
