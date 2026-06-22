# shellcheck disable=SC2148
# System Management
alias reSource="source ~/.bashrc"
alias ll="ls -la --color=auto"

alias g="git"
alias dotfiles-update="cd \$HOME/.dotfiles && git pull && cd - && reSource"
alias dotfiles-update-force="cd \$HOME/.dotfiles && git fetch --all && git reset --hard origin/trunk && cd -"
alias dotfiles-cd="cd \$HOME/.dotfiles"
alias special_clean="special_filename_clean && special_remove_subfolder && special_rename"
