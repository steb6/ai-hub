---
name: ai-hub
description: Use the three agent plans on this machine (claude-personal, claude-work, codex) without wasting or exhausting them. Check remaining 5-hour and weekly quota with `ai-usage`, delegate work to another account with `ai-ask`, and pick account and model by task complexity, time and cost. Use before starting any large or long task, before spawning sub-work, when a limit is close, when the user asks about usage, quota, tokens, which model or which account to use, or asks to delegate to Codex or to the other Claude.
---

# ai-hub: quota and delegation across accounts

Three plans, one machine. All sessions share them, so check before spending.

## 1. Look

```
ai-usage            # table: 5h used, week used, weekly pace, reset times, quota left now
ai-usage --json     # same, for scripts
```

- `left`: percent usable right now (the tighter of the 5-hour and weekly windows).
- `pace`: percent of the week already elapsed. `week used` far below `pace` = plan being wasted.
- `use next`: the work account with the most quota left.

## 2. The policy

- **`claude-personal` must never run out.** It is the account the project sessions and the
  coordinator themselves run on; if it hits a limit, everything stops. Hard stop at 85% of the
  5-hour limit and 90% of the weekly limit. Your own turns already spend it, so keep them
  light: plan, delegate, check the result.
- **`claude-work` and `codex` are there to be used up.** Running them to 100% is fine. Quota
  that resets unused is lost.
- So any real piece of work — implementing, debugging, reviewing, analysing, researching —
  goes to a work account with `ai-ask`, to the one with the most quota left (`auto`).
  Do it yourself only when it is quicker than writing the prompt.
- If one work account is finished, use the other. If both are finished, continue on
  `claude-personal` only while it is under its limits, then stop and tell the user.

## 3. Delegate

```
ai-ask [-w] [-m MODEL] <claude-work|claude-personal|codex|auto> "prompt"
```

- Runs headless in the **current directory**; the answer comes back on stdout.
- Read-only by default. `-w` lets the agent edit files and run commands.
- `auto` picks the work account with the most quota left. Use it unless you want a specific vendor.
- The other agent starts with no memory of your conversation. Write a self-contained prompt:
  goal, relevant paths, constraints, and what to return (and how short).
- One writer per repository at a time. For parallel writers use separate git worktrees.
- Tasks longer than a couple of minutes: run `ai-ask` in the background and keep working.
- A different vendor is the best second opinion: ask `codex` to review Claude's diff and the other way round.

Good to delegate: code review, bug hunt over a large codebase, writing tests, a mechanical
refactor, log or dataset analysis, a literature or doc search, a second opinion on a design.
Not worth it: anything that takes you under a minute, or needs your whole conversation as context.

## 4. Pick the model

Use a model smart enough to get it right the first time. A weak model that needs a second
round wastes more time than it saves quota, and the work plans have room. The defaults of
`ai-ask` are already the strong ones; change them only with a reason.

| task | Claude (`-m`) | Codex (`-m`) |
|---|---|---|
| default: coding, debugging, review, analysis | `opus` (default) | `gpt-6-astra` (default) |
| hardest: subtle bug, architecture, research reasoning, long autonomous task | `fable` | `gpt-6-astra` |
| trivial and bulk only: rename, reformat, grep-and-summarise many files | `sonnet` | `gpt-5.6-sol` |

Step down a tier only when the account you need is nearly finished and the task is easy.
Do not use `haiku` or `gpt-reserve` for anything that requires judgement.

## 5. Compute is the other resource

GPUs and disks are shared with colleagues. Use the `hsp-workstation` skill before any heavy job.

## Files

`~/.ai-hub/CONTEXT.md` global context · `~/.ai-hub/log.tsv` log of every delegation ·
`~/.ai-hub/bin/` the commands. Usage is read from each account's own endpoint with the local
login; if a row shows ERROR, that login expired — tell the user.
