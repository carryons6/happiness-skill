#!/usr/bin/env bash
#
# Research Guardrail skill installer for Codex (macOS / Linux)
#
#   curl -fsSL https://raw.githubusercontent.com/carryons6/research-guardrail-skill/main/install.sh | bash
#
# Installs the skill into  $CODEX_HOME/skills/research-guardrail  (default ~/.codex/skills/research-guardrail).
# Re-running updates an existing install. Environment overrides:
#   CODEX_HOME            Codex home dir            (default: ~/.codex)
#   RESEARCH_GUARDRAIL_REF         branch or tag to install  (default: main)
#   RESEARCH_GUARDRAIL_REPO_URL    git clone URL
#   RESEARCH_GUARDRAIL_REPO_TARBALL  tarball URL used when git is unavailable
#
set -euo pipefail

SKILL_NAME="research-guardrail"
REF="${RESEARCH_GUARDRAIL_REF:-main}"
REPO_URL="${RESEARCH_GUARDRAIL_REPO_URL:-https://github.com/carryons6/research-guardrail-skill.git}"
REPO_TARBALL="${RESEARCH_GUARDRAIL_REPO_TARBALL:-https://github.com/carryons6/research-guardrail-skill/archive/refs/heads/${REF}.tar.gz}"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="$CODEX_HOME/skills"
TARGET_DIR="$SKILLS_DIR/$SKILL_NAME"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarning:\033[0m %s\n' "$*" >&2; }
err()  { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

info "Installing the '$SKILL_NAME' skill into $TARGET_DIR"
mkdir -p "$SKILLS_DIR"

# Back up a pre-existing non-git install so we never clobber local edits silently.
if [ -e "$TARGET_DIR" ] && [ ! -d "$TARGET_DIR/.git" ]; then
  backup="$TARGET_DIR.backup.$(date +%Y%m%d%H%M%S)"
  warn "Existing install found at $TARGET_DIR; moving it to $backup"
  mv "$TARGET_DIR" "$backup"
fi

if command -v git >/dev/null 2>&1; then
  if [ -d "$TARGET_DIR/.git" ]; then
    info "Updating existing install (git)"
    git -C "$TARGET_DIR" fetch --depth 1 origin "$REF"
    git -C "$TARGET_DIR" checkout -q "$REF" 2>/dev/null || git -C "$TARGET_DIR" checkout -q -B "$REF" "origin/$REF"
    git -C "$TARGET_DIR" reset --hard -q "origin/$REF"
  else
    info "Cloning $REPO_URL ($REF)"
    git clone --depth 1 --branch "$REF" "$REPO_URL" "$TARGET_DIR"
  fi
else
  warn "git not found; falling back to downloading a tarball"
  command -v tar >/dev/null 2>&1 || err "Neither git nor tar is available; cannot install."
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$REPO_TARBALL" -o "$tmp/research-guardrail.tar.gz"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$tmp/research-guardrail.tar.gz" "$REPO_TARBALL"
  else
    err "Need curl or wget to download the skill."
  fi
  mkdir -p "$TARGET_DIR"
  tar -xzf "$tmp/research-guardrail.tar.gz" -C "$TARGET_DIR" --strip-components=1
fi

[ -f "$TARGET_DIR/SKILL.md" ] || err "Install finished but $TARGET_DIR/SKILL.md is missing; something went wrong."

info "Done. The '$SKILL_NAME' skill is installed at $TARGET_DIR"
info "Restart Codex so it can discover the new skill."
