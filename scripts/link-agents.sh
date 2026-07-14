#!/usr/bin/env bash
# Link the repo's AGENTS.md to every installed agent harness's global
# instruction path, and ensure AGENTS.md is git-ignored.
#
# Confirmed global instruction paths (from official docs):
#   Codex        ~/.codex/AGENTS.md            https://developers.openai.com/codex/guides/agents-md
#   Claude Code  ~/.claude/CLAUDE.md           https://code.claude.com/docs/en/memory
#   OpenCode     ~/.config/opencode/AGENTS.md  https://opencode.ai/docs/rules/
#   Grok Build   ~/.grok/AGENTS.md             https://docs.x.ai/build/features/project-rules
#   Antigravity  ~/.gemini/GEMINI.md           https://www.scriptbyai.com/antigravity-cli-cheatsheet/  ("global developer context")

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_ROOT/AGENTS.md"
GITIGNORE="$REPO_ROOT/.gitignore"

if [[ ! -f "$SRC" ]]; then
  echo "error: $SRC not found" >&2
  exit 1
fi

# --- 1. Ensure AGENTS.md is git-ignored -------------------------------------
ensure_gitignore() {
  local entry="AGENTS.md"
  if [[ -f "$GITIGNORE" ]] && grep -qxF "$entry" "$GITIGNORE"; then
    return
  fi
  printf '\n# agent harness global instruction source (symlinked out)\n%s\n' "$entry" >> "$GITIGNORE"
  echo "gitignore: added '$entry' to $GITIGNORE"
}

# --- 2. Link one harness ----------------------------------------------------
#   $1 = display name       $2 = absolute target path   $3 = config dir (for detection)
link_harness() {
  local name="$1" target="$2" config_dir="$3"
  # Detection: harness is installed if its config dir exists or its binary is on PATH.
  if ! [[ -d "$config_dir" ]] && ! command -v "${name,,}" >/dev/null 2>&1; then
    echo "[$name] not detected (no $config_dir, no '${name,,}' on PATH) — skipped"
    return
  fi
  # Already linked to the same source? nothing to do.
  if [[ -L "$target" && "$(readlink -f "$target")" == "$(readlink -f "$SRC")" ]]; then
    echo "[$name] already linked -> $target"
    return
  fi
  # Make sure parent dir exists (harness config dir may have been created elsewhere).
  mkdir -p "$(dirname "$target")"
  # Preserve any existing file/empty-symlink by backing it up before linking.
  if [[ -e "$target" || -L "$target" ]]; then
    if [[ -f "$target" ]] && cmp -s "$target" "$SRC"; then
      # Same content — safe to drop the bare file and replace with a symlink.
      rm "$target"
      echo "[$name] replaced identical $target with symlink"
    else
      local backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
      mv "$target" "$backup"
      echo "[$name] backed up existing $target -> $backup"
    fi
  fi
  ln -s "$SRC" "$target"
  echo "[$name] linked $target -> $SRC"
}

ensure_gitignore

link_harness "codex"       "$HOME/.codex/AGENTS.md"            "$HOME/.codex"
link_harness "claude"      "$HOME/.claude/CLAUDE.md"           "$HOME/.claude"
link_harness "opencode"    "$HOME/.config/opencode/AGENTS.md"  "$HOME/.config/opencode"
link_harness "grok"        "$HOME/.grok/AGENTS.md"             "$HOME/.grok"
link_harness "antigravity" "$HOME/.gemini/GEMINI.md"           "$HOME/.gemini"

echo
echo "Done. Source of truth: $SRC"
