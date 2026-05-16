#~/.bashrc
# Fernando Chairez - dotfiles
# Compatibility: Ubuntu · Arch · Fedora

# Iteractive shell
[[ $- != *i* ]] && return

# History
HISTCONTROL=ignorespace:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT="%Y-%m-%d %H:%M  "
shopt -s histappend

# Terminal
shopt -s checkwinsize

if command -v lesspipe &>/dev/null; then
  eval "$(SHELL=/bin/sh lesspipe)"
fi

shopt -s cdspell # corrige typos menores en rutas de cd (ej: cd Dcouments → Documents)
shopt -s autocd  # escribe una ruta sin cd y entra directo

# Distro detection
DISTRO=""
if [ -f /etc/os-release ]; then
  . /etc/os-release
  DISTRO="${ID:-unknown}"
fi

# Prompt
_git_branch() {
  local branch
  branch=$(git branch 2>/dev/null | grep '^\*' | cut -d' ' -f2-)
  [ -n "$branch" ] && echo " ($branch)"
}

_prompt_symbol() {
  [ "${_last_exit:-0}" -ne 0 ] && echo "✗ "
}

PROMPT_COMMAND='_last_exit=$?'

if tput setaf 1 &>/dev/null; then
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;33m\]$(_git_branch)\[\033[00m\] \[\033[01;31m\]$(_prompt_symbol)\[\033[00m\]\$ '
else
  PS1='\u@\h:\w$(_git_branch) $(_prompt_symbol)\$ '
fi

case "$TERM" in
xterm* | rxvt* | alacritty* | foot*)
  PS1="\[\e]0;\u@\h: \w\a\]$PS1"
  ;;
esac

# PATH
_add_path() {
  [ -d "$1" ] && PATH="$1:$PATH"
}

_add_path "$HOME/.local/bin"
_add_path "$HOME/.npm-global/bin"
_add_path "/usr/local/go/bin"
_add_path "/opt/nvim-linux-x86_64/bin"

[ "$DISTRO" = "ubuntu" ] && _add_path "/snap/bin"

export PATH

# Environment Variables
#
if command -v batcat &>/dev/null; then
  export MANPAGER='batcat -plman'
elif command -v bat &>/dev/null; then
  export MANPAGER='bat -plman'
fi

export LEDGER_FILE="$HOME/finance/hledger/2026.journal"

# MOTD
case "$HOSTNAME" in
arsia)
  clear
  [ -f ~/.welcome ] && cat ~/.welcome
  echo ""
  command -v tpendientes &>/dev/null && tpendientes
  echo ""
  command -v landscape-sysinfo &>/dev/null && landscape-sysinfo
  echo ""
  ;;
tharsys.club)
  # Respetar el MOTD del tilde club
  echo ""
  ;;
*)
  # Local, WSL, otros — sin MOTD
  echo ""
  ;;
esac

# Aliases and Completions
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

[ -f ~/.bash_aliases_extra ] && . ~/.bash_aliases_extra

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# opencode
export PATH=/home/fchairezd/.opencode/bin:$PATH
