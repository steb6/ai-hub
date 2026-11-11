# Global context (shared by every Claude and Codex session on this machine)

Single source: `~/.ai-hub/CONTEXT.md`. `~/.claude/CLAUDE.md`, `~/.claude-work/CLAUDE.md` and
`~/.codex/AGENTS.md` are links to it. Edit this file only.

## Who you work for
<!-- Fill in: name, group, what you work on, where projects live. Keep it short: every
     session loads this file at start. -->
NAME, ROLE at GROUP. Work: WHAT YOU DO. Projects live under `~`, one session per project.

How they work:
<!-- Fill in your own rules. Examples: -->
- Language and length of answers you want.
- Plan first and wait for a yes, or just go.
- Things never to do (sudo, posting to external services, ...).

## Two kinds of resources — use both well

**1. Compute (GPU workstations, Slurm, HPC).** Before starting or moving any training, eval,
download or heavy job, use the `hsp-workstation` skill: it lists the machines, gives a live
GPU/disk status and the sharing rules. Never take a GPU someone else is using.

**2. Agents (three paid plans, all usable from here).**

| name | what | start interactively |
|---|---|---|
| `claude-personal` | Claude Code, personal plan (small) | `claude` |
| `claude-work` | Claude Code, work Team plan | `claude-work` |
| `codex` | Codex CLI, work plan | `codex` |

Each plan has a 5-hour and a weekly limit. Policy:
- `claude-personal` is what the project sessions and the coordinator run on: it must never
  run out. Keep your own turns light.
- `claude-work` and `codex` should be used up within the week. Send every real piece of work
  there: `ai-ask auto "self-contained prompt"` (add `-w` if it must edit files). It picks the
  account with the most quota left and a strong model by default.
- Prefer strong models; do not lose time with weak ones.

Run `ai-usage` to see what is left. Details and model table: the `ai-hub` skill — load it
before delegating or when quota matters. Full notes: `~/.ai-hub/README.md`.
