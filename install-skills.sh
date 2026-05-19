#!/usr/bin/env bash
# Install Blueprint skills for Claude Code
# Supports both local run (./install-skills.sh) and remote (curl | bash).
set -euo pipefail

REPO_URL="https://github.com/imbue-ai/blueprint.git"
SKILLS_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills"

cleanup() {
  if [ -n "${TEMP_DIR:-}" ] && [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
  fi
}

main() {
  # Determine source directory: local repo or shallow clone
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd)" || SCRIPT_DIR=""

  if [ -n "$SCRIPT_DIR" ] && [ -d "$SCRIPT_DIR/skills" ]; then
    # In-repo mode: create symlinks for live editing
    echo "Detected in-repo run. Installing skills via symlinks..."
    mkdir -p "$SKILLS_DIR"

    for skill_dir in "$SCRIPT_DIR/skills"/*/; do
      skill_name="$(basename "$skill_dir")"
      dst="$SKILLS_DIR/$skill_name"

      if [ -L "$dst" ]; then
        echo "  Updating existing symlink for $skill_name..."
        rm "$dst"
      elif [ -e "$dst" ]; then
        echo "  Error: $dst already exists and is not a symlink. Remove it manually."
        exit 1
      fi

      ln -s "$skill_dir" "$dst"
      echo "  Installed: $skill_name (symlink)"
    done
  else
    # Standalone mode: shallow clone and copy
    echo "Downloading Blueprint skills..."
    TEMP_DIR="$(mktemp -d)"
    trap cleanup EXIT
    git clone --depth 1 "$REPO_URL" "$TEMP_DIR" 2>/dev/null

    echo "Installing Blueprint skills..."
    mkdir -p "$SKILLS_DIR"

    for skill_dir in "$TEMP_DIR/skills"/*/; do
      skill_name="$(basename "$skill_dir")"
      dst="$SKILLS_DIR/$skill_name"

      if [ -L "$dst" ]; then
        rm "$dst"
      fi
      rm -rf "$dst"
      cp -r "$skill_dir" "$dst"
      echo "  Installed: $skill_name"
    done
  fi

  echo ""
  echo "Installation complete!"
  echo ""
  echo "Commands:"
  echo "  /blueprint <description>      Start a new plan session with Q&A"
  echo "  /blueprint-generate            Generate the plan from Q&A"
}

main "$@"
