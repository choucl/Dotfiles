#!/usr/bin/env bash
# Link each installed harness to the shared AGENTS.md or to a generated copy
# with its optional agent-overlays/<harness>.md appended.
#
# Confirmed global instruction paths (from official docs):
#   Codex        ~/.codex/AGENTS.md            https://developers.openai.com/codex/guides/agents-md
#   Claude Code  ~/.claude/CLAUDE.md           https://code.claude.com/docs/en/memory
#   OpenCode     ~/.config/opencode/AGENTS.md  https://opencode.ai/docs/rules/
#   Grok Build   ~/.grok/AGENTS.md             https://docs.x.ai/build/features/project-rules
#   Antigravity  ~/.gemini/GEMINI.md           https://antigravity.google/docs/rules

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_ROOT/AGENTS.md"
OVERLAYS="$REPO_ROOT/agent-overlays"
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

write_combined() (
  local overlay="$1" output="$2" temporary
  mkdir -p -- "$(dirname -- "$output")"
  temporary="$(mktemp -- "$output.XXXXXX")"
  trap 'rm -f -- "$temporary"' EXIT
  {
    cat -- "$SRC"
    printf '\n\n'
    cat -- "$overlay"
  } > "$temporary"
  if ! cmp -s -- "$temporary" "$output"; then
    mv -fT -- "$temporary" "$output"
  fi
)

# $1 = harness name, $2 = instruction path, $3 = config dir, $4 = optional CLI name.
link_harness() (
  local name="$1" target="$2" config_dir="$3" cli="${4:-$1}"
  local overlay="$OVERLAYS/$name.md" combined="$OVERLAYS/.generated/$name.md"
  local source="$SRC" staging
  if [[ ! -d "$config_dir" ]] && ! command -v "$cli" "$name" >/dev/null 2>&1; then
    echo "[$name] not detected — skipped"
    return
  fi

  if [[ -f "$overlay" && -s "$overlay" ]]; then
    write_combined "$overlay" "$combined"
    source="$combined"
  fi
  if [[ -L "$target" && "$target" -ef "$source" ]]; then
    echo "[$name] $target -> $source"
    return
  fi

  mkdir -p -- "$(dirname -- "$target")"
  staging="$(mktemp -d -- "${target}.tmp.XXXXXX")"
  trap 'rm -f -- "$staging/link"; rmdir -- "$staging"' EXIT
  ln -s -- "$source" "$staging/link"

  if [[ -L "$target" && ( "$target" -ef "$SRC" || "$target" -ef "$combined" ) ]] ||
     { [[ -f "$target" ]] && cmp -s -- "$target" "$SRC"; }; then
    mv -fT -- "$staging/link" "$target"
  else
    # Keep any independently managed instructions alongside the new link.
    mv -fT --backup=numbered -- "$staging/link" "$target"
  fi
  echo "[$name] linked $target -> $source"
)

ensure_gitignore

link_harness "codex"       "$HOME/.codex/AGENTS.md"            "$HOME/.codex"
link_harness "claude"      "$HOME/.claude/CLAUDE.md"           "$HOME/.claude"
link_harness "opencode"    "$HOME/.config/opencode/AGENTS.md"  "$HOME/.config/opencode"
link_harness "grok"        "$HOME/.grok/AGENTS.md"             "$HOME/.grok"
link_harness "antigravity" "$HOME/.gemini/GEMINI.md"           "$HOME/.gemini" "agy"

echo
echo "Done. Source of truth: $SRC"
