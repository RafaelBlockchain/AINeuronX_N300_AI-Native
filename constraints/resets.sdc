# ============================================
# Reset Constraints (STA v1)
# ============================================

# Asynchronous reset assertion
set_false_path -from [get_ports rst_n]

# De-assertion is synchronous (handled by reset_sync)
# No additional timing constraints required

# Prevent optimization removal
set_dont_touch_network [get_ports rst_n]
