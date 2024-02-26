# TODO

- ~~migrate from makefile to install.sh script~~
- package installs?
  - install.sh per package?
- cli
  - zsh
  - neovim
  - fzf
  - bat
  - rg
  - fd
  - exa
  - lsd
  - handlr
- gui
  - zathura
  - feh
  - firefox
- document system level changes?
  - greetd/sway
  - nvidia (?)
    - mkinit stuff
  - pam
    - pam-u2f.so
    - pam_rssh
  - networkd
    - bind fallback
  - pacman
    - Color
    - UseSyslog
    - VerbosePkgLists

## pam

- unlock gpg-agent/ssh-agent on login
  - pass pin from login directly to agents?

## email

- migrate to local email server
- setup mail client
  - MUA
    - aerc
    - mutt
  - Maildir
    - OfflineIMAP
    - fdm
      - mailctl
  - mailnotify

## zk

- might not be best option for todos
- use fzf-tmux for interactive selection
- fails when `$ZK_NOTEBOOK_DIR` is set to hidden dir
  - e.g. `export ZK_NOTEBOOK_DIR="$HOME/.notebook"`

## ssh

- possible to use pam_u2f over ssh?
  - if not, alternative for sudo auth without password
    - [pam_rssh](https://github.com/z4yx/pam_rssh)

## tmux

- emulate sway workspace switching
  - on C-#, if tab # does not exist, create it and switch
  - move active tab to # with S-#
- add keymap for opening zk/todos in initial session
- yank
  - fix yanking whitespace under prompt
  - add vim-like keymaps for yanking start>end/cursor>end/cursor>start
  - add vim-like keymaps for deleting start>end/cursor>end/cursor>start
  - add vim-like keymaps for selecting start>end/cursor>end/cursor>start
- tmux-sessionizer
  - improve search
    - long runtime on initial search
    - more robust filter
  - add keybind for creating repo from current input value
    - zk does this, start there
- ssh session management
  - nested sessions
  - remap C-s to ssh-sessionizer
    - tmux-sessionizer but for ssh targets
  - remap C-S to ssh-switcher
    - tmux-sessions but for connected/existing ssh targets
  - run different local tmux config if connecting to remote tmux session
    - hides local UI
    - remote all remaps except for the "switch ssh/host"
- rewrite in rust?
  - unify all tools into single rust binary
    - tmuxctl create
      - tmux-sessionizer
    - tmuxctl switch
      - tmux-sessions
    - tmuxctl switch --ssh
    - tmuxctl create --ssh
  - host/session creating
  - host/session switching

## nvim

- fix lua syntax highlighting bug
- fix lag when quickly navigating (large?) files, e.g. plugins.lua
- setup harpoon
  - possible to replace tabline with harpoon marks? (currently buffers)
- reorganize lsp configs
- reorganize dap configs
- fix lsp document symbols error in sh files

## wsl

- delay usbip service ExecStart until server started
  - run on user slice (but needs to be run root?)
- fix having to restart wsl for clipboard support
  - possibly done by changing the startup task on windows?

## sway

- toggle swayidle/swaylock
- pipewire
  - set default audio sink (Possibly fixed?)
    - session manager?
  - add filter config to dotfiles (done)
- firefox
  - crash when reorganizing tabs
    - [bug](https://bugzilla.mozilla.org/show_bug.cgi?id=1721453)
  - crash when reloading sway
- discord
  - crashing on screenshare (when sharing OR viewing)
- notifications
  - streamlink-gui not using notify daemon
- swayr
  - rebind
    - alt-tab mru
    - $mod-tab select window
- window layouts
  - floating
  - pulseaudio volume control
  - workspace ordering (1-2 on output 1?)
  - open streamlink stuff on output 2
- swaybar
  - open pulseaudio volume control on volume click
  - fix media not updating
- rbw
  - possibly move to [pass](https://www.passwordstore.org/)?
  - login issues
    - dep services wait until unlocked?
