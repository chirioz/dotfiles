# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  # Tu nuevo estilo con soporte para chroot y colores limpios
  PS1='${debian_chroot:+($debian_chroot)}\[\e[34m\]\u@\h\[\e[0m\] \[\e[5m\]⁂\[\e[0m\] :\[\e[94m\]\w\[\e[0m\] \$ '
else
  # Versión sin color (mantiene el estándar si la terminal no soporta color)
  PS1='${debian_chroot:+($debian_chroot)}\u@\h ⁂ :\w \$ '
fi
unset color_prompt force_color_prompt

# Si es un xterm, añade el título de la ventana (manteniendo la lógica original)
case "$TERM" in
xterm* | rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*) ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi

export MANPAGER='bat -plman'
# export LEDGER_FILE='/home/fchairezd/finance/hledger/2026/04.journal'
export LEDGER_FILE='/home/fchairezd/finance/hledger/2026.journal'
export PATH=/usr/local/go/bin
export PATH=/usr/local/sbin:/usr/local/lib:/usr/lib:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/opt/nvim-linux-x86_64/bin:/home/fchairezd/.local/bin:/usr/local/go/bin

# MOTD
clear
cat -p ~/.welcome
echo ""
tpendientes
echo ""
landscape-sysinfo
echo ""
export PATH="$HOME/.npm-global/bin:$PATH"
