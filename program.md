# MBPP Solver

Improve a Python code generation solver to maximize pass@1 on MBPP.

## Setup

1. Read the repo files for full context:
   - `program.md` — this file
   - `prepare.sh` — downloads MBPP dataset. Do not modify.
   - `eval/eval.sh` — runs evaluation. Do not modify.
   - `agent.py` — the file you modify. The code generator.
2. Verify data exists: Check that `data/` contains `test.jsonl`. If not, run `bash prepare.sh`.
3. Run the baseline: `bash eval/eval.sh`

## Experimentation

Each experiment runs on the test set (500 problems). Run: `bash eval/eval.sh`

**What you CAN do:**
- Modify `agent.py` — prompting strategy, few-shot examples, chain-of-thought, self-repair, code extraction, retry logic.

**What you CANNOT do:**
- Modify `prepare.sh` or `eval/eval.sh`.
- Change the model (set via `SOLVER_MODEL` env var).
- Install new packages beyond `requirements.txt`.

**The goal**: Maximize pass@1 — fraction of problems where your generated code passes all test assertions.

## Output format

The eval prints:
```
---
accuracy:         0.6500
correct:          325
total:            500
```

## The experiment loop

LOOP FOREVER:
1. **THINK** — review results, form a hypothesis.
2. Modify `agent.py`.
3. `git add -A && git commit -m "description"`
4. `bash eval/eval.sh > run.log 2>&1`
5. Check results: `grep "^accuracy:" run.log`
6. If improved, keep. If worse, `git revert HEAD`.
7. NEVER STOP.
