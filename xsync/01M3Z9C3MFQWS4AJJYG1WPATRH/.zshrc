# Version: 03-10-26
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH=$PATH:~/code/scripts
export PATH=$PATH:~/.local/bin
export PATH="$PATH:$HOME/go/bin"

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config ~/omp/standard.omp.json)"
fi

if [ ! -L "$HOME/Proton" ]; then
  ln -s "$HOME/Library/CloudStorage/ProtonDrive-mail@stevevine.uk-folder" "$HOME/Proton"
  echo "Linked ProtonDrive to ~/Proton"
fi

eval "$(zoxide init zsh)"
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /opt/homebrew//share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# History file and size
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000

# Zsh options
setopt APPEND_HISTORY           # Append to history file, don't overwrite
#setopt SHARE_HISTORY            # Share history between sessions
setopt INC_APPEND_HISTORY       # Add commands to history immediately
setopt HIST_IGNORE_DUPS         # Ignore duplicate commands
setopt HIST_REDUCE_BLANKS       # Remove superfluous blanks
setopt HIST_VERIFY              # Don't execute history line immediately
setopt EXTENDED_HISTORY         # Record timestamp of each command

# periodically reload history
#autoload -Uz add-zsh-hook
#function sync-history() {
#  fc -AI                                # Append and re-read history file
#}
#add-zsh-hook precmd sync-history        # Run before each prompt

# Change current folder with lf
lfcd () {
    tmpfile="$(mktemp)"
    lf -last-dir-path="$tmpfile" "$@"
    if [ -f "$tmpfile" ]; then
        dir="$(cat "$tmpfile")"
        rm -f "$tmpfile"
        [ -d "$dir" ] && cd "$dir"
    fi
}

# FZF History Search (Ctrl+R replacement)
fzf-history-widget() {
  local selected
  selected=$(history 1 | fzf --tac +s --reverse)
  if [[ -n "$selected" ]]; then
    LBUFFER="${selected##*[0-9]  }"  # Strip everything up to last number+space
  fi
}

# summon
export SUMMON_BIN=$HOME/code/summon/summon

summon() {
  local cmd_file="${TMPDIR}.summon_cmd"
  local query_file="${TMPDIR}.summon_query"
  local bin="${SUMMON_BIN:-summon}"
  local exit_code

  # ── Quick-pick mode (default) ────────────────────────────────────────────
  "$bin" "$@"
  exit_code=$?

  # Tab was pressed → escalate to the full popup TUI, restoring the query.
  if [[ $exit_code -eq 3 ]]; then
    local query=""
    if [[ -f "$query_file" ]]; then
      query=$(<"$query_file")
      rm -f "$query_file"
    fi

    local full_args=("--full")
    [[ -n "$query" ]] && full_args+=("--filter" "$query")

    # Full TUI may loop (ReturnAfterRun) so keep running until it's done.
    while true; do
      "$bin" "${full_args[@]}"
      exit_code=$?

      [[ -f "$cmd_file" ]] || break

      local cmd; cmd=$(<"$cmd_file"); rm -f "$cmd_file"
      [[ -n "$cmd" ]] && print -z "$cmd"

      [[ $exit_code -eq 2 ]] || break
    done
    return
  fi

  # ── Quick mode ran to completion (Enter pressed or quit) ─────────────────
  [[ -f "$cmd_file" ]] || return

  local cmd; cmd=$(<"$cmd_file"); rm -f "$cmd_file"
  [[ -n "$cmd" ]] && print -z "$cmd"
}


zle -N fzf-history-widget
bindkey '^H' fzf-history-widget

# Alias'
alias s="summon"
alias tm="tmux-keys.sh"

alias ls="ls -G"
alias cls="clear"
alias wa="watch "

alias kl="kubectl"
alias kx="kubectx"
alias cx="kubie ctx" echo -ne "\e[5 q"
alias ns="kubie ns"

alias python="python3"

alias sessions="tmux ls"                                # List all sessions
alias session="tmux switch-client -t"                   # Switch to session <name>
alias new-session="tmux new -ds"                        # Create new session <name>
alias kill-session="tmux kill-session -t"               # Delete session <name>
alias rename-session="tmux rename-session -t"           # rename current session <name>
alias attach-session="tmux attach -t"                   # Attach to existing session <name>
alias detach-session="tmux detatch"                     # Detatch from current session (Quit TMUX)

alias aws-login=". aws-login-svine.sh"
alias ec2='mosh --ssh="ssh -i ~/.ssh/rv.pem" ubuntu@dev.redvektor.net -- tmux new -A -s'
alias g5="mosh steve@g5.citops.net"