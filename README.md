# ai-hub

Use several AI coding plans from one machine without wasting or exhausting them.

Typical case: a personal Claude plan, a work Claude plan and a work Codex plan. Each has a
5-hour and a weekly limit, they do not know about each other, and the work plans reset unused
while the personal one runs dry. ai-hub makes every agent session on the machine aware of
all three, able to see what is left, and able to hand work to the others.

## What you get

| | |
|---|---|
| `ai-usage` | Table of 5-hour and weekly usage for every account, reset times, and which account to use next. |
| `ai-ask` | Hand a task to another account, headless, in the current directory. Read-only unless `-w`. Refuses an account that reached its limit. |
| `claude-work` | Claude Code on the second (work) profile. |
| `ai-hub` skill | Tells the agent when to delegate and which model to pick. Installed for Claude Code and Codex. |
| `CONTEXT.md` | One global instruction file (who you are, how you work, the resources), loaded by every Claude and Codex session. |

```
$ ai-usage
account          plan   5h used      reset  week used  pace      reset  left
claude-personal  pro        36% Wed 11 14:19        11%    5% Wed 18 02:59   64%
claude-work      team        0% Wed 11 15:49         0%   73% Fri 13 07:59  100%
codex            edu         0% Wed 11 15:54         2%   77% Fri 13 01:24   98%
use next: claude-work  (most quota left; claude-personal is kept in reserve)

$ ai-ask auto "Review the diff of the last commit in this repo for bugs. Reply with a short list."
$ ai-ask -w -m fable claude-work "Fix the failing test in tests/test_io.py and run the suite."
```

## The policy it encodes

- The account your interactive sessions run on (`claude-personal`) must never run out:
  hard stop at 85% of the 5-hour limit and 90% of the weekly limit.
- The other plans (`claude-work`, `codex`) are there to be used up within the week.
- Sessions stay light: they plan, delegate real work with `ai-ask auto`, and check the result.
- Strong models by default (`opus`, `gpt-6-astra`); a weak model that needs a second round
  costs more time than it saves.

Limits are two lines at the top of `bin/ai-usage`; default models are in `bin/ai-ask`; the
rules the agents read are in `skill/ai-hub/SKILL.md`. Change them to taste.

## Setup

Needs Linux or macOS, Python 3.9+, [Claude Code](https://claude.com/claude-code) and
[Codex CLI](https://github.com/openai/codex), both logged in with a subscription.

1. Log in to the second Claude account in its own profile. Your existing sessions keep
   running: they use `~/.claude`, this one uses `~/.claude-work`.
   ```
   CLAUDE_CONFIG_DIR=~/.claude-work claude
   ```
   Open the login link in a **private browser window** and sign in with the work account
   (a normal window would silently authorise the account you are already signed in with).
2. Install:
   ```
   git clone https://github.com/steb6/ai-hub ~/.ai-hub
   ~/.ai-hub/install.sh
   ```
3. Edit `~/.ai-hub/CONTEXT.md` (created from `CONTEXT.example.md`, not tracked by git).
4. Sessions started from now on know everything. To sessions that were already open, say:
   "read `~/.ai-hub/CONTEXT.md` and `~/.ai-hub/skill/ai-hub/SKILL.md`".

Times are shown in `Europe/Rome`; set `AI_HUB_TZ` to change.

## Good to know

- **Usage is read from undocumented endpoints** (the ones the tools' own `/usage` and
  `/status` screens call), with the login tokens already stored on your machine. Nothing is
  sent anywhere else. A tool update can break this: `ai-usage` then shows `ERROR` for that
  account and `ai-ask` refuses it unless you pass `-f`.
- **It is guidance, not enforcement.** An interactive session still runs on its own account
  and decides when to delegate. The only hard block is inside `ai-ask`.
- **Delegated agents start with no memory** of the calling conversation: prompts must be
  self-contained.
- **One writer per repository at a time.** Use git worktrees for parallel writers.
- **Check your organisation's rules** before sending work code to a personal account or
  personal code to a work account.
- On macOS Claude Code keeps credentials in the Keychain, not in `.credentials.json`:
  `ai-usage` needs adapting there. Tested on Linux only.
