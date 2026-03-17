#!/usr/bin/env bash
set -euo pipefail
mkdir -p data
echo "Downloading MBPP..."
python3 -c "
from datasets import load_dataset
import json, pathlib

dev = load_dataset('google-research-datasets/mbpp', 'sanitized', split='validation')
dev_out = pathlib.Path('data/dev.jsonl')
with dev_out.open('w') as f:
    for row in dev:
        f.write(json.dumps({'task_id': row['task_id'], 'prompt': row['prompt'], 'code': row['code'], 'test_list': row['test_list']}) + '\n')

test = load_dataset('google-research-datasets/mbpp', 'sanitized', split='test')
test_out = pathlib.Path('data/test.jsonl')
with test_out.open('w') as f:
    for row in test:
        f.write(json.dumps({'task_id': row['task_id'], 'prompt': row['prompt'], 'code': row['code'], 'test_list': row['test_list']}) + '\n')

print(f'Dev:  {len(dev)} problems -> {dev_out}')
print(f'Test: {len(test)} problems -> {test_out}')
"
echo "Done."
