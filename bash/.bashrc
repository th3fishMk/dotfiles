# Shell History
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend
export HISTCONTROL=ignoreboth:erasedups
if [[ ! "$PROMPT_COMMAND" =~ "history -a; history -c; history -r" ]]; then
    PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
fi

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Aliases and functions
if [ -f "$HOME/.dotfiles/bash/.bash-aliases" ]; then
    . "$HOME/.dotfiles/bash/.bash-aliases"
fi
if [ -f "$HOME/.dotfiles/bash/.bash-functions" ]; then
    . "$HOME/.dotfiles/bash/.bash-functions"
fi

# Add bin dir to path
if [ -d "$HOME/.dotfiles/bin" ]; then
    PATH="$HOME/.dotfiles/bin:$PATH"
fi
# Add script dir to path
if [ -d "$HOME/.dotfiles/scripts" ]; then
    PATH="$HOME/.dotfiles/scripts:$PATH"
fi
export PATH

# making terminal pretty
parse_git_branch() {
    # Fail fast if outside a git repository
    git rev-parse --is-inside-work-tree &>/dev/null || return

    local branch toplevel repo_name relpath localpath state symbol

    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    toplevel=$(git rev-parse --show-toplevel 2>/dev/null) || return
    repo_name=$(basename "$toplevel")
    relpath=$(git rev-parse --show-prefix 2>/dev/null)

    if [ -z "$relpath" ]; then
        localpath="${repo_name}/"
    else
        localpath="${repo_name}/${relpath}"
    fi

    # Optimize tracking speed via combined porcelain status assessment
    if ! git diff --quiet 2>/dev/null || ! git diff --quiet --cached 2>/dev/null; then
        state="dirty"
        symbol="✗"
    elif [ -n "$(git log --branches --not --remotes 2>/dev/null)" ]; then
        state="unpushed"
        symbol="↑"
    else
        state="clean"
        symbol="✓"
    fi

    echo "$branch|$localpath|$state|$symbol"
}

build_prompt() {
    # local exit_status=$?
    local info color branch prefix state symbol

    info=$(parse_git_branch)

    # Base configuration: user@hostname:cwd
    PS1='\[\033[0;32m\]\u@\h\[\033[0m\]:\[\033[0;34m\]\W\[\033[0m\]'

    if [ -n "$info" ]; then
        IFS="|" read -r branch prefix state symbol <<<"$info"
        case "$state" in
        "dirty") color="\[\033[0;31m\]" ;;    # Red
        "unpushed") color="\[\033[0;33m\]" ;; # Yellow
        *) color="\[\033[0;32m\]" ;;          # Green
        esac
        PS1+=" ${color}(${branch} ${symbol} | ${prefix})\[\033[0m\]"
    fi

    # Indicate command line context execution terminal ($ or # for root)
    PS1+=' \$ '
}

PROMPT_COMMAND="build_prompt; $PROMPT_COMMAND"

# # Rust stuff
# if [ -f "$HOME/.cargo/env" ]; then
#     . "$HOME/.cargo/env"
# fi

# # Nvm
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# # pnpm
# export PNPM_HOME="/home/$USER/.local/share/pnpm"
# case ":$PATH:" in
# *":$PNPM_HOME/bin:"*) ;;
# *) export PATH="$PNPM_HOME/bin:$PATH" ;;
# esac
# # pnpm end

# # More pretty stuff in the terminal
# if command -v fastfetch &>/dev/null; then
#     fastfetch
# fi
