# shellcheck disable=SC2148
# ====================================================================
# Global Definitions & System Defaults
# ====================================================================
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# ====================================================================
# User Environment & PATH Adjustments
# ====================================================================
# Prevent duplicate prepends if bashrc is sourced multiple times
if ! [[ "$PATH" =~ $HOME/.local/bin:$HOME/bin: ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Safely source Rust/Cargo environment only if it exists
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# ====================================================================
# Shell History Tuning
# ====================================================================
HISTSIZE=10000
HISTFILESIZE=20000

# Append history instead of overwriting, ignore duplicates and common typos
shopt -s histappend
export HISTCONTROL=ignoreboth:erasedups

# Sync history across multiple active terminal windows instantaneously
# Guarded against loops by strictly managing existing PROMPT_COMMAND states
if [[ ! "$PROMPT_COMMAND" =~ "history -a; history -c; history -r" ]]; then
    PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
fi

# ====================================================================
# Terminal Interface & Keybindings
# ====================================================================
# Enable incremental history search with up/down arrows
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

if [ -f "$HOME/.bash-aliases" ]; then
    . "$HOME/.bash-aliases"
fi

if [ -f "$HOME/.bash-functions" ]; then
    . "$HOME/.bash-functions"
fi

# Retain Fedora's native drop-in directory parsing safely
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

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

# Add custom dotfiles bin directory to the system PATH
if [ -d "$HOME/.dotfiles/bin" ]; then
    PATH="$HOME/.dotfiles/bin:$PATH"
fi
export PATH
# Export scripts
if [ -d "$HOME/.dotfiles/scripts" ]; then
    PATH="$HOME/.dotfiles/scripts:$PATH"
fi
export PATH

# Render prompt strings safely with optimized terminal coloring sequences
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

# ====================================================================
# System Diagnostics Visualizer
# ====================================================================
if command -v fastfetch &>/dev/null; then
    fastfetch
fi

# pnpm
export PNPM_HOME="/home/th3fishmk/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME/bin:"*) ;;
*) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# fnm
FNM_PATH="/home/th3fishmk/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
    export PATH="$FNM_PATH:$PATH"
    eval "$(fnm env --shell bash)"
fi
