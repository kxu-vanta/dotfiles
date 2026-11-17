#!/usr/bin/env bash
# Dotfiles installer. Ona (and Codespaces) run this automatically in new environments.
# Safe to re-run: every step checks before it acts.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
log() { printf '[dotfiles] %s\n' "$*"; }

# --- system packages (only where apt + sudo exist, e.g. Ona Ubuntu images) ---
if command -v apt-get >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
  missing=()
  for pkg in zsh vim fzf git curl; do
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

# --- Vundle + vim plugins ---
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
  log "installing Vundle"
  git clone -q --depth=1 https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
fi
if command -v vim >/dev/null 2>&1; then
  log "installing vim plugins"
  vim -E -s -u "$HOME/.vimrc" +PluginInstall +qall </dev/null >/dev/null 2>&1 || true
fi

# --- make zsh the default shell ---
if command -v zsh >/dev/null 2>&1; then
  zsh_path="$(command -v zsh)"
  if [ "${SHELL:-}" != "$zsh_path" ] && sudo -n true 2>/dev/null; then
    sudo chsh -s "$zsh_path" "$(id -un)" && log "default shell set to zsh" || true
  fi
fi

log "done"
