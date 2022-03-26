# Opts
HYPHEN_INSENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
DISABLE_AUTO_TITLE="true"
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt NO_BEEP
setopt MENU_COMPLETE
setopt auto_pushd             # auto push to the directory stack on cd
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

# Exports
export ZDOTDIR=${XDG_CONFIG_HOME:-$HOME/.config}/zsh
export FZF_PREVIEW_COMMAND="bat --style=numbers,changes --wrap never --color always {} || cat {} || tree -C {}"
export FZF_DEFAULT_COMMAND="fd --type f || git ls-tree -r --name-only HEAD || rg --files || find ."
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--min-height 30 --preview-window down:60% --preview-window noborder --preview '($FZF_PREVIEW_COMMAND) 2> /dev/null'"
export GOPATH=$HOME/.go
typeset -A ZSH_HIGHLIGHT_STYLES
export ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern line)
export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)

# Load ZDOTDIR
for f in $ZDOTDIR/*.*sh; do source $f; done

# Misc
command -v fd &>/dev/null && _fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

command -v fd &>/dev/null && _fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

eval "$(starship init zsh 2>/dev/null)"

set_win_title() {
  local prefix

  if [ "$USER" != "tobyv" ]; then
    prefix="${USER} in "
  fi

  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    prefix="${prefix/in/on}${HOST} in "
  fi

  echo -ne "\033]0;${prefix}${PWD/$HOME/~}\007"
}

precmd_functions+=(set_win_title)

bindkey '^ ' autosuggest-accept
bindkey '^[[Z' reverse-menu-complete

# Plugins
function plugin-load {
  local repo plugin_name plugin_dir initfile initfiles
  export ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}
  for repo in $@; do
    plugin_name=${repo:t}
    plugin_dir=$ZPLUGINDIR/$plugin_name
    initfile=$plugin_dir/$plugin_name.plugin.zsh

    if [[ ! -d $plugin_dir ]]; then
      echo "Cloning $repo"
      git clone -q --depth 1 --recursive --shallow-submodules https://github.com/$repo $plugin_dir
    fi

    if [[ ! -e $initfile ]]; then
      initfiles=($plugin_dir/*.plugin.{z,}sh(N) $plugin_dir/*.{z,}sh{-theme,}(N))
      [[ ${#initfiles[@]} -gt 0 ]] || { echo "Plugin has no init file '$repo'."  >&2 && continue }
      ln -sf "${initfiles[1]}" "$initfile"
    fi

    fpath+=$plugin_dir
    (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
  done
}

repos=(
  romkatv/zsh-defer
  jirutka/zsh-shift-select
  zsh-users/zsh-completions
  Aloxaf/fzf-tab
  joshskidmore/zsh-fzf-history-search
  srijanshetty/zsh-pandoc-completion
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-autosuggestions
)

plugin-load $repos

function comp-load {
  local comp src name comp_file
  export ZCOMPDIR=${ZCOMPDIR:-${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions}
  mkdir -p $ZCOMPDIR
  for comp in $@; do
    src="$(echo $comp | sed 's/[:][^:]*$//')"
    name="$(echo $comp | sed 's/.*[:]//' | sed 's/^[^_]/_&/')"

    if [[ -n $name ]]; then
      name="$(basename $src | sed 's/^[^_]/_&/')"
    fi

    comp_file=$ZCOMPDIR/$name

    if [[ ! -f $comp_file ]]; then
      curl -sL https://raw.githubusercontent.com/$src >$comp_file
    fi
  done

  fpath+=$ZCOMPDIR

  autoload -U compinit
  compinit -i

  zstyle ':completion:*' menu select
}

comps=(
  dotnet/cli/master/scripts/register-completions.zsh:_dotnet
  docker/cli/master/contrib/completion/zsh/_docker
)
