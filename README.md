# dotfiles

My shell and editor setup for remote dev environments (Ona, Codespaces), applied automatically when an environment starts.

## Setup

1. In Ona, open **Settings → Preferences → Dotfiles** and set the repository to:
   ```
   https://github.com/kxu-vanta/dotfiles.git
   ```
2. Start a new environment. Ona clones this repo and runs `install.sh` on its own. Environments that were already running don't pick up the change.

To run it by hand (on any Linux or macOS machine):

```bash
git clone https://github.com/kxu-vanta/dotfiles.git ~/dotfiles && ~/dotfiles/install.sh
```

The script is safe to re-run: each step checks before it acts.

## What `install.sh` does

1. **System packages:** installs `zsh`, `vim`, `fzf`, `git`, `curl` and `python3` if missing. This only happens where `apt-get` and passwordless `sudo` are available.
2. **Oh My Zsh:** clones it into `~/.oh-my-zsh` if it isn't there.
3. **Dotfiles:** symlinks `.zshrc` and `.vimrc` into `$HOME`. An existing file is renamed to `<name>.pre-dotfiles` first.
4. **Git editor:** runs `git config --global core.editor vim`. `.zshrc` also unsets `GIT_EDITOR` (Cursor/VS Code terminals set it to the IDE, which overrides `core.editor`) and exports `EDITOR=vim` and `VISUAL=vim`.
5. **Cursor / VS Code:** sets `remote.autoForwardPorts` and `remote.restoreForwardedPorts` to `false` in the remote machine settings (`~/.cursor-server/data/Machine/settings.json` and `~/.vscode-server/...`). Other settings in those files are kept.
6. **Default shell:** switches the login shell to zsh when `sudo` allows it.

## Files

| File | Purpose |
| --- | --- |
| `install.sh` | Setup script, run automatically by Ona |
| `.zshrc` | Oh My Zsh config, aliases, git helpers, editor variables |
| `.vimrc` | Leader key and key mappings |

## Troubleshooting

- **Nothing seems to have run:** look for lines starting with `[dotfiles]` in the environment's startup logs, or run `~/dotfiles/install.sh` (or wherever Ona cloned it) by hand.
- **Edits to `~/.zshrc` or `~/.vimrc`:** they're symlinks into this repo, so commit and push from the clone to keep changes for future environments.
