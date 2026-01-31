from models.transformer import transformer_block

def test_transformer():
    instrs = transformer_block("Q","K","V","W","O")
    assert len(instrs) == 2
