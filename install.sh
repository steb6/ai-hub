#!/usr/bin/env bash
# Links ai-hub into Claude Code (personal + work profile) and Codex. Safe to re-run.
# Never overwrites an existing CLAUDE.md / AGENTS.md: it tells you to merge by hand.
set -euo pipefail
HUB=$(cd "$(dirname "$0")" && pwd)
[ "$HUB" = "$HOME/.ai-hub" ] || { echo "Clone this repo to ~/.ai-hub (scripts expect that path)."; exit 1; }
[ -f "$HUB/CONTEXT.md" ] || { cp "$HUB/CONTEXT.example.md" "$HUB/CONTEXT.md"; echo "Created CONTEXT.md from the template: edit it."; }
mkdir -p ~/.local/bin; chmod +x "$HUB"/bin/*; ln -sf "$HUB"/bin/* ~/.local/bin/
link_ctx() {  # $1 = target file
  if [ -L "$1" ] || [ ! -s "$1" ]; then ln -sf "$HUB/CONTEXT.md" "$1"; echo "linked $1"
  else echo "SKIPPED $1 (already has content): move its content into CONTEXT.md, delete it, re-run."; fi
}
for d in ~/.claude ~/.claude-work ~/.codex; do
  [ -d "$d" ] || { echo "no $d: skipped (log in to that tool first, then re-run)"; continue; }
  mkdir -p "$d/skills"; ln -sfn "$HUB/skill/ai-hub" "$d/skills/ai-hub"
  [ "$d" = ~/.codex ] && link_ctx "$d/AGENTS.md" || link_ctx "$d/CLAUDE.md"
done
echo; "$HUB/bin/ai-usage" || true
