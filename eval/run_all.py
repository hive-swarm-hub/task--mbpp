"""Evaluate agent.py on all MBPP problems."""
import json
import subprocess
import sys

data_path = sys.argv[1]

with open(data_path) as f:
    problems = [json.loads(line) for line in f]

total = len(problems)
correct = 0

for data in problems:
    try:
        proc = subprocess.run(
            ["python3", "agent.py"],
            input=json.dumps(data), capture_output=True, text=True, timeout=30,
        )
        if proc.returncode != 0:
            continue
        code = proc.stdout.strip()
        test_code = "\n".join(data["test_list"])
        exec(code + "\n" + test_code, {})
        correct += 1
    except Exception:
        pass

print("---")
print(f"accuracy:         {correct / total:.6f}")
print(f"correct:          {correct}")
print(f"total:            {total}")
