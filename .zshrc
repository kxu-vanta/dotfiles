# ~/.zshrc (symlinked from ~/dotfiles by install.sh)
# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME="robbyrussell"

export PATH="$HOME/.local/bin:$PATH"

# Editor: Cursor/VS Code terminals set GIT_EDITOR to themselves, which beats core.editor.
unset GIT_EDITOR
export EDITOR=vim
export VISUAL=vim

# Codex Alias
# alias cc="claude --dangerously-skip-permissions"
alias cc="codex --dangerously-bypass-approvals-and-sandbox"

alias ppp="pnpm pp"

# Peon Ping
export PEON_RELAY_HOST=localhost
alias peon="bash $HOME/.claude/hooks/peon-ping/peon.sh"

# Aliases
alias c='clear'
alias ls="ls -ltFh"
alias l="ls -ltFh"
alias v='vim'
alias evim='vim ~/.vimrc'
alias ezsh='vim ~/.zshrc'
alias szsh='source ~/.zshrc'
alias j='jump'
alias histg='history | grep '
alias histf='history | fzf '
alias cafe='caffeinate'

# git stuff
alias gs='git status'
alias gaf='git add $(fzf)'
alias gd='git diff'
alias gdc='git diff --cached'
alias gco='git checkout'
alias gr='git rebase'
alias gls='git log --stat'
alias glp='git log -p'
alias glpr='git log --pretty=oneline'
alias glg="git log --graph --pretty=format':%C(yellow)%h%Cblue%d%Creset %s %C(white) %an, %ar%Creset'"
alias gb='git branch'
alias gsl='git stash list'
alias gcp='git cherry-pick'
alias gpo='git push origin'         # push.default = current
alias gundo='git reset HEAD~'
alias gpum='git pull upstream master'

#tmux stuff
alias tm='tmux'

unalias gss 2>/dev/null
gss() {
    git stash show -p stash@{$1}
}

gsa() {
    git stash apply stash@{$1}
}

unalias gsd 2>/dev/null
gsd() {
    git stash drop stash@{$1}
}

# because typing 'cd' is A LOT of work!!
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

# Keep 100,000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

export PROMPT='$PROMPT$(git-radar --zsh --fetch) '

plugins=(jump sudo sublime)

source $ZSH/oh-my-zsh.sh

# Peon Ping tab completion
[ -f "$HOME/.claude/hooks/peon-ping/completions.bash" ] && source "$HOME/.claude/hooks/peon-ping/completions.bash"

# remove ls and directory completion highlight color (must stay after oh-my-zsh is sourced)
# https://josh-ops.com/posts/github-codespaces-powerlevel10k/
_ls_colors=':ow=01;33'
zstyle ":completion:*:default" list-colors "${(s.:.)_ls_colors}"
LS_COLORS+=$_ls_colors
