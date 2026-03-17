# MBPP Solver

Improve a Python code generation solver to maximize pass@1 on MBPP.

## Setup

1. **Read the in-scope files**: The repo is small. Read these files for full context:
   - `agent.py` — the file you modify. The code generator.
   - `eval/eval.sh` — runs evaluation. Do not modify.
   - `eval/run_all.py` — evaluation runner. Do not modify.
   - `prepare.sh` — downloads MBPP dataset. Do not modify.
2. **Run prepare**: `bash prepare.sh` to download the dataset.
3. **Verify data exists**: Check that `data/` contains `test.jsonl`. If not, run `bash prepare.sh`.
4. **Initialize results.tsv**: Create `results.tsv` with just the header row.
5. **Run baseline**: `bash eval/eval.sh` to establish the starting accuracy.

## The benchmark

MBPP (Mostly Basic Python Programs) evaluates code generation from natural language descriptions. Each problem provides:
- A task description (e.g., "Write a function to find the maximum element in a list")
- Test assertions that the generated code must pass

Total: **257 test problems**. The agent generates a Python function, and the eval runs it against the test assertions.

## Experimentation

**What you CAN do:**
- Modify `agent.py` — this is the only file you edit. Everything is fair game: prompting strategy, few-shot examples, chain-of-thought, self-repair, code extraction, retry logic.

**What you CANNOT do:**
- Modify `eval/`, `prepare.sh`, or test data.
- Change the model. The model is fixed (set via `SOLVER_MODEL` env var).
- Install new packages beyond what's in `requirements.txt`.

**The goal: maximize pass@1 accuracy.** A problem "passes" when the generated code executes all test assertions without error. Accuracy = fraction of problems that pass.

**Cost** is a soft constraint. Some increase in API calls is acceptable for meaningful gains, but prefer single-pass solutions.

**Simplicity criterion**: All else being equal, simpler is better. A small improvement that adds ugly complexity is not worth it.

**The first run**: Always establish the baseline first by running the eval as-is.

## Output format

The eval prints a summary:

```
---
accuracy:         0.6500
correct:          167
total:            257
```

You can extract the key metric:

```
grep "^accuracy:" run.log
```

## Logging results

Log each experiment to `results.tsv` (tab-separated):

```
commit	accuracy	cost_usd	status	description
a1b2c3d	0.650000	0.42	keep	baseline
b2c3d4e	0.710000	0.50	keep	few-shot examples + self-repair
```

## The experiment loop

LOOP FOREVER:

1. **THINK** — decide what to try next. This is the most important step. Review your results.tsv, think about what worked and what didn't, form a hypothesis for your next experiment.
2. Modify `agent.py` with your experimental idea.
3. git commit
4. Run the experiment: `bash eval/eval.sh > run.log 2>&1`
5. Read out the results: `grep "^accuracy:" run.log`
6. If the grep output is empty, the run crashed. Run `tail -n 50 run.log` for the stack trace and attempt a fix.
7. Record the results in results.tsv (do not commit results.tsv).
8. If accuracy improved (higher), keep the git commit. If equal or worse, `git reset --hard HEAD~1`.

**Timeout**: If a run exceeds 30 minutes, kill it and treat it as a failure.

**Crashes**: If it's a dumb fix (typo, bad format), fix and re-run. If fundamentally broken, skip it.

**NEVER STOP**: Once the loop begins, do NOT pause to ask the human. The human might be asleep. You are autonomous. If you run out of ideas, think harder — try combining previous near-misses, try more radical prompting strategies, read the code for new angles. The loop runs until interrupted.
