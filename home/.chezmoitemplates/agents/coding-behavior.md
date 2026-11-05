## Coding Behavior
- Think before coding: state assumptions. If a request has more than one reading, name them instead of picking silently. If something is unclear, stop and ask. Say so when a simpler approach exists.
- Simplicity: write the minimum code that solves the problem. No unrequested features or configurability, no abstractions for single-use code, and no error handling for impossible cases.
- Surgical changes: every changed line should trace to the request. Don't reformat, refactor, or "improve" adjacent code or comments, and match the existing style. Remove only the orphans your change created; mention unrelated dead code instead of deleting it.
- Verify: turn the task into a checkable goal (a failing test that reproduces the bug, tests passing before and after a refactor) and loop until it's met. For multi-step work, state a short plan with a check for each step.
