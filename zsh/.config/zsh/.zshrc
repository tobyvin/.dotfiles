# Opts
HYPHEN_INSENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
DISABLE_AUTO_TITLE="true"
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt no_beep
setopt menu_complete
setopt auto_pushd             # auto push to the directory stack on cd
setopt auto_cd                # cd without args
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

# Exports
typeset -A ZSH_HIGHLIGHT_STYLES
export ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern line)
export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)

# Aliases
alias ls='ls --color=tty'
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias lla='ls -lA'
alias lsa='ls -lah'
alias grep='grep --color'
alias ipa="ip -s -c -h a"
alias untar="tar -zxvf"
alias td=". td.sh"
alias vim=nvim
alias dexec="docker exec -it"
alias dps="docker ps"
alias dc="docker compose"
alias dce="docker compose exec"
alias dcps="docker compose ps"
alias dcls="docker compose ls"
alias dcdn="docker compose down"
alias dcup="docker compose up"
alias dcupd="docker compose up -d"
alias dcl="docker compose logs"
alias dclf="docker compose logs -f"
alias dct="docker context"
alias dcu="docker context use"

# Misc
command -v fd &>/dev/null && _fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

command -v fd &>/dev/null && _fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# Keybinds
bindkey -e
bindkey '^ ' autosuggest-accept
bindkey '^[[Z' reverse-menu-complete

# Prompt/plugins
command -v starship &>/dev/null && source <(starship init zsh)
command -v sheldon &>/dev/null && source <(sheldon source)
