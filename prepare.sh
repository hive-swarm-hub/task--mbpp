#!/usr/bin/env bash
set -euo pipefail
mkdir -p data

echo "Downloading MBPP test set..."
python3 -c "
from datasets import load_dataset
import json, pathlib

ds = load_dataset('google-research-datasets/mbpp', 'sanitized', split='test')
out = pathlib.Path('data/test.jsonl')
with out.open('w') as f:
    for row in ds:
        f.write(json.dumps({
            'task_id': row['task_id'],
            'prompt': row['prompt'],
            'code': row['code'],
            'test_list': row['test_list'],
        }) + '\n')

print(f'Wrote {len(ds)} problems to {out}')
"
echo "Done. $(wc -l < data/test.jsonl) problems in data/test.jsonl"
