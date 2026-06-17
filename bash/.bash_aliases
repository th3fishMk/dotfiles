# shellcheck disable=SC2148
# System Management
alias reSource="source ~/.bashrc"
alias ll="ls -la --color=auto"

alias g="git"
alias dotfiles-update="cd \$HOME/.dotfiles && git pull && cd -"
alias dotfiles-update-force="cd \$HOME/.dotfiles && git fetch --all && git reset --hard origin/trunk && cd -"
alias dotfiles-cd="cd \$HOME/.dotfiles"

