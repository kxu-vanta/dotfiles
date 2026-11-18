#!/usr/bin/env bash
# Dotfiles installer. Ona (and Codespaces) run this automatically in new environments.
# Safe to re-run: every step checks before it acts.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
log() { printf '[dotfiles] %s\n' "$*"; }

# --- system packages (only where apt + sudo exist, e.g. Ona Ubuntu images) ---
if command -v apt-get >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
  missing=()
  for pkg in zsh vim fzf git curl python3; do
    command -v "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
  done
  if [ ${#missing[@]} -gt 0 ]; then
    log "installing: ${missing[*]}"
    sudo apt-get update -qq
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq "${missing[@]}" || log "apt install failed, continuing"
  fi
fi

# --- Oh My Zsh (.zshrc sources it) ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  log "installing oh-my-zsh"
  git clone -q --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi

# --- link dotfiles into $HOME (back up anything already there) ---
for f in .zshrc .vimrc; do
  target="$HOME/$f"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$target.pre-dotfiles"
    log "backed up existing $f to $f.pre-dotfiles"
  fi
  ln -sfn "$DOTFILES/$f" "$target"
  log "linked $f"
done

# --- git: vim as editor (GIT_EDITOR is unset in .zshrc so this wins) ---
git config --global core.editor vim
log "git core.editor = vim"

# --- Cursor / VS Code remote settings: stop auto port forwarding ---
# Machine settings live on the remote, so they apply to this environment whichever client connects.
merge_settings() {
  local file="$1"
  mkdir -p "$(dirname "$file")"
  python3 - "$file" <<'PY'
import json, sys, os
path = sys.argv[1]
data = {}
if os.path.exists(path):
    try:
        with open(path) as f:
            data = json.load(f)
    except ValueError:
        os.rename(path, path + ".bak")  # JSONC or broken; keep a copy, start fresh
data.update({"remote.autoForwardPorts": False, "remote.restoreForwardedPorts": False})
with open(path, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PY
}
if command -v python3 >/dev/null 2>&1; then
  for d in .cursor-server .vscode-server; do
    merge_settings "$HOME/$d/data/Machine/settings.json"
  done
  log "disabled remote port auto-forwarding"
else
  log "python3 missing, skipped Cursor settings"
fi

# --- Codex skills from kxstack (private repo: needs Ona's GitHub credentials) ---
KXSTACK_REPO="${KXSTACK_REPO:-https://github.com/kxu-vanta/kxstack.git}"
KXSTACK_DIR="$HOME/.kxstack"
if [ -d "$KXSTACK_DIR/.git" ]; then
  GIT_TERMINAL_PROMPT=0 git -C "$KXSTACK_DIR" pull -q --ff-only || log "kxstack pull failed, using existing checkout"
else
  GIT_TERMINAL_PROMPT=0 git clone -q "$KXSTACK_REPO" "$KXSTACK_DIR" </dev/null \
    || log "couldn't clone kxstack (check Ona's GitHub access to it), skipping Codex skills"
fi
if [ -d "$KXSTACK_DIR/skills" ]; then
  SKILLS_DIR="${CODEX_HOME:-$HOME/.codex}/skills"
  mkdir -p "$SKILLS_DIR"
  # drop links to skills that no longer exist in kxstack
  for link in "$SKILLS_DIR"/*; do
    [ -L "$link" ] && [ ! -e "$link" ] && case "$(readlink "$link")" in "$KXSTACK_DIR"/*) rm "$link" ;; esac
  done
  for s in "$KXSTACK_DIR"/skills/*/; do
    [ -d "$s" ] || continue
    name="$(basename "$s")"
    if [ -e "$SKILLS_DIR/$name" ] && [ ! -L "$SKILLS_DIR/$name" ]; then
      log "skipping skill $name: $SKILLS_DIR/$name already exists and isn't a link"
      continue
    fi
    ln -sfn "${s%/}" "$SKILLS_DIR/$name"
  done
  log "linked Codex skills: $(ls "$KXSTACK_DIR/skills" | tr '\n' ' ')"
fi

# --- make zsh the default shell ---
if command -v zsh >/dev/null 2>&1; then
  zsh_path="$(command -v zsh)"
  if [ "${SHELL:-}" != "$zsh_path" ] && sudo -n true 2>/dev/null; then
    sudo chsh -s "$zsh_path" "$(id -un)" && log "default shell set to zsh" || true
  fi
fi

log "done"
