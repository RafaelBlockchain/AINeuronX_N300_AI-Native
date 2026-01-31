def print_report(metrics):
    print("\n=== AINeuronX N200 Performance Report ===")
    for k, v in metrics.items():
        print(f"{k:20s}: {v}")
