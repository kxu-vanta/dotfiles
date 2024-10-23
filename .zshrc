# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="robbyrussell"

alias p="python3 -W ignore"

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

alias grepex='grep --exclude-dir=node_modules -rni '

# Git shortcuts
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
alias gb='git branch --list'
alias gsl='git stash list'
alias gcp='git cherry-pick'
alias gpo='git push origin'         # push.default = current
alias gundo='git reset HEAD~'
alias gpum='git pull upstream master'

# `cd` shortcuts
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

# Keep 100,000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

plugins=(jump)

source $ZSH/oh-my-zsh.sh

# User configuration
export PATH=/usr/local/sbin:$PATH
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/usr/local/Cellar/mysql/5.6.17_1/bin:$PATH
