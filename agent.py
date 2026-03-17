"""MBPP solver — generates Python code from task descriptions.

Takes a task description on stdin, prints the Python function on stdout.
"""

import sys
import os
import re

from openai import OpenAI


def solve(prompt: str, test_list: list[str]) -> str:
    """Generate Python code for an MBPP task. Return the code as a string."""
    client = OpenAI()

    response = client.chat.completions.create(
        model=os.environ.get("SOLVER_MODEL", "gpt-4.1-nano"),
        messages=[
            {"role": "system", "content": "Write a Python function to solve the task. Output ONLY the function code, no explanations."},
            {"role": "user", "content": f"Task: {prompt}\n\nTest cases:\n" + "\n".join(test_list)},
        ],
        temperature=0,
        max_tokens=512,
    )

    code = response.choices[0].message.content.strip()
    # Extract code from markdown blocks if present
    match = re.search(r'```(?:python)?\s*\n(.*?)```', code, re.DOTALL)
    if match:
        code = match.group(1).strip()
    return code


if __name__ == "__main__":
    import json
    data = json.loads(sys.stdin.read().strip())
    print(solve(data["prompt"], data["test_list"]))
