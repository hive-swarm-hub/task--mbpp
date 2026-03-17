#!/usr/bin/env bash
set -euo pipefail
mkdir -p data
echo "Downloading MBPP..."
python3 -c "
from datasets import load_dataset
import json, pathlib, random
random.seed(42)
val = list(load_dataset('google-research-datasets/mbpp', 'sanitized', split='validation'))
random.shuffle(val)
with pathlib.Path('data/train.jsonl').open('w') as f:
    for row in val[:100]:
        f.write(json.dumps({'task_id': row['task_id'], 'prompt': row['prompt'], 'code': row['code'], 'test_list': row['test_list']}) + '\n')
test = list(load_dataset('google-research-datasets/mbpp', 'sanitized', split='test'))
random.shuffle(test)
with pathlib.Path('data/test.jsonl').open('w') as f:
    for row in test[:100]:
        f.write(json.dumps({'task_id': row['task_id'], 'prompt': row['prompt'], 'code': row['code'], 'test_list': row['test_list']}) + '\n')
print(f'Train: {min(len(val),100)}, Test: {min(len(test),100)}')
"
echo "Done."
