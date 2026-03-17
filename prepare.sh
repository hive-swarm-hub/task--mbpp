#!/usr/bin/env bash
set -euo pipefail
mkdir -p data
echo "Downloading MBPP..."
python3 -c "
from datasets import load_dataset
import json, pathlib, random

random.seed(42)

dev = list(load_dataset('google-research-datasets/mbpp', 'sanitized', split='validation'))
random.shuffle(dev)
dev_out = pathlib.Path('data/dev.jsonl')
with dev_out.open('w') as f:
    for row in dev[:150]:
        f.write(json.dumps({'task_id': row['task_id'], 'prompt': row['prompt'], 'code': row['code'], 'test_list': row['test_list']}) + '
')

test = list(load_dataset('google-research-datasets/mbpp', 'sanitized', split='test'))
random.shuffle(test)
test_out = pathlib.Path('data/test.jsonl')
with test_out.open('w') as f:
    for row in test[:150]:
        f.write(json.dumps({'task_id': row['task_id'], 'prompt': row['prompt'], 'code': row['code'], 'test_list': row['test_list']}) + '
')

print(f'Dev:  {min(len(dev),150)} problems -> {dev_out}')
print(f'Test: {min(len(test),150)} problems -> {test_out}')
"
echo "Done."
