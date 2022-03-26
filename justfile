# set positional-arguments := true

EMAIL := 'tobyv13@gmail.com'
ZSH_COMP_DIR := join(env_var('HOME'), '/.local/share/zsh/site-functions')
BASH_COMP_DIR := join(env_var('HOME'), '/.local/share/bash-completion/completions')

stow:
    stow --target={{ env_var('HOME') }} */

unstow:
    stow --target={{ env_var('HOME') }} --delete */

install +TARGETS:
    for target in {{TARGETS}}; do just $target; done

rustup:
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    rustup completions bash >{{ BASH_COMP_DIR }}/completions/rustup;
    rustup completions zsh >{{ ZSH_COMP_DIR }}/_rustup;
    rustup completions bash cargo >{{ BASH_COMP_DIR }}/completions/cargo;
    rustup completions zsh cargo >{{ ZSH_COMP_DIR }}/_cargo)

cargo:
    command -v cargo || just rustup
    command -v cargo-quickinstall || cargo install cargo-quickinstall

starship: cargo
    cargo quickinstall starship --locked
    starship completions bash >{{ BASH_COMP_DIR }}/completions/starship;
    starship completions zsh >{{ ZSH_COMP_DIR }}/_starship

# Install manually with cargo see https://github.com/sharkdp/bat/issues/2106
bat:
    cargo quickinstall bat --target {{ arch() }}-unknown-{{ os() }}-mus
    curl -sL https://raw.githubusercontent.com/sharkdp/bat/master/assets/completions/bat.bash.in >{{ BASH_COMP_DIR }}/completions/bat
    curl -sL https://raw.githubusercontent.com/sharkdp/bat/master/assets/completions/bat.zsh.in >{{ ZSH_COMP_DIR }}/_bat

fd:
    cargo quickinstall fd-find
    curl -sL https://raw.githubusercontent.com/sharkdp/fd/master/contrib/completion/_fd >{{ ZSH_COMP_DIR }}/_fd

ripgrep:
    cargo install ripgrep
    curl -sL https://raw.githubusercontent.com/BurntSushi/ripgrep/master/complete/_rg >{{ ZSH_COMP_DIR }}/_rg

chtsh:
    curl https://cht.sh/:cht.sh >~/.local/bin/cht.sh
    chmod +x ~/.local/bin/cht.sh
    curl https://cht.sh/:bash_completion >{{ BASH_COMP_DIR }}/completions/cht
    curl https://cheat.sh/:zsh >{{ ZSH_COMP_DIR }}/_cht

git-open:
    curl -sL "https://raw.githubusercontent.com/paulirish/git-open/master/git-open" >~/.local/bin/git-open &&
    chmod +x ~/.local/bin/git-open;

gh:
    #!/usr/bin/env bash
    set -euxo pipefail
    td=$(mktemp -d)
    arch="$(uname -m | sed s/aarch64/arm64/ | sed s/x86_64/amd64/ | sed s/armv7l/armv6/)"
    tag="$(curl -sI https://github.com/cli/cli/releases/latest | grep -Po 'tag\/v?\K(\S+)')"
    name="gh_${tag}_linux_${arch}"
    url="https://github.com/cli/cli/releases/latest/download/${name}.tar.gz"
    curl -sL $url | tar -C $td -xz
    test -x $td/$name/bin/gh
    install -Dm 755 $td/$name/bin/gh ~/.local/bin/gh
    rm -rf $td
    gh completion --shell bash >{{ BASH_COMP_DIR }}/gh
    gh completion --shell zsh >{{ ZSH_COMP_DIR }}/_gh

fzf:
    #!/usr/bin/env sh
    set -euxo pipefail
    td=$(mktemp -d)
    tag="$(curl -sI https://github.com/junegunn/fzf/releases/latest | grep -Po 'tag\/v?\K(\S+)')"
    alt_arch="$(echo {{arch()}} | sed s/aarch64/arm64/ | sed s/x86_64/amd64/ | sed s/armv7l/armv7/)"
    name="fzf-${tag}-{{ os() }}_${alt_arch}"
    url="https://github.com/junegunn/fzf/releases/latest/download/${name}.tar.gz"
    curl -sL $url | tar -C $td -xz
    test -x $td/fzf
    rm -f ~/.local/bin/fzf
    install -Dm 755 $td/fzf ~/.local/bin/fzf
    rm -rf $td
    curl -sL https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.bash >{{ BASH_COMP_DIR }}/completions/fzf
    curl -sL https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh >{{ ZSH_COMP_DIR }}/_fzf
    curl -sL https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.bash >~/.bash/fzf-key-bindings.sh
    curl -sL https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh >~/.zsh/fzf-key-bindings.zsh 

gpg:
    gpg --auto-key-locate keyserver --locate-keys {{ EMAIL }}
    gpg --import-ownertrust {{ join(env_var('HOME'), '.gnupg/trustfile.txt') }}
