# build-laconic

An opencode primary agent that mirrors the built-in `build` agent — full
read/edit/write/bash/search capability and the same rigor — but compresses
every chat response to minimum tokens.

## Files

- `build-laconic.md` — the agent. `name: build-laconic` in frontmatter pins the
  agent name regardless of the containing folder, so this file can live in a
  subdirectory under `agents/`.

## Loading

opencode scans `{agent,agents}/**/*.md` (recursive). The agent name comes from
the path relative to `agent(s)/`, but a `name:` field in frontmatter overrides
it — which is why nesting in `build-laconic/` still yields name `build-laconic`.

Restart opencode after adding or editing the file; config is loaded once at
startup and is not hot-reloaded.

## Design

Laconic is a compression directive, not a persona — no Spartan voice, no wit,
no flavor. Output style only; tool use, planning, TDD, and debugging discipline
are unchanged from the default build agent.

Synthesized from two open-source `laconic` skills:

- <https://github.com/PekkaSetala/laconic/blob/master/skills/laconic/SKILL.md>
  — structure: preserve/cut lists, intensity levels, anti-persona guardrails,
  artifact passthrough, and auto-clarity safety carve-outs (security warnings,
  destructive-action confirmations).
- <https://github.com/GabrielBarberini/laconic/blob/main/skills/laconic/SKILL.md>
  — linguistic moves: simplest word over synonym, one proposition per sentence,
  condition-before-instruction, length inversely proportional to input,
  parataxis over subordination, let implication carry the judgment.
