# Colors
if command -v dircolors &>/dev/null; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# My aliases
# Base tools
if command -v eza &>/dev/null; then
  alias ls='eza -F --group-directories-first --sort=modified --icons=auto --color=auto'
  alias ll='eza -lhgF --group-directories-first --sort=modified --icons=auto'
  alias la='eza -alhgF --group-directories-first --sort=modified --icons=auto'
  alias l='eza -F -1 --group-directories-first --sort=modified --icons=auto'
  alias tree='eza -T --icons=auto'
else
  alias ll='ls -lh'
  alias la='ls -lha'
  alias l='ls -1'
fi

alias grep='grep --color=auto'

if command -v batcat &>/dev/null; then
  alias bat='batcat'
  alias cat='batcat'
elif command -v bat &>/dev/null; then
  alias cat='bat'
fi

# Dotfiles
alias bashrc='${EDITOR:-nvim} ~/.bashrc'
alias aliases='${EDITOR:-nvim} ~/.bash_aliases'
alias reload='source ~/.bashrc'

# Utility
alias cls='clear'

if command -v trash-put &>/dev/null; then
  alias rm='echo Este no es el comando que buscas. Prueba trashput o \\rm.; false'
fi

alias clima='curl -H "Accept-Language: es" "wttr.in/CiudadJuarez?F&T"'

# Tareas
alias tasks='nn tareas'

# Notas
function n() {
  if [ -z "$1" ]; then
    #l "$HOME/notes/"
    (cd "$HOME/notes" && find . -path "*/.*" -prune -o -type f -print0 | xargs -0 eza -1 --sort=modified --color=always --icons=always | tail -n 20)
  elif [ "$1" = "s" ] || [ "$1" = "o" ]; then
    local busqueda="${*:2}"
    (cd "$HOME/notes" && archivo=$(fzf --query="$busqueda" --preview 'bat --color=always --style=numbers --line-range=:500 {}' --prompt="Notas> ") && [ -n "$archivo" ] && nvim "$archivo")
  elif [ "$1" = "n" ]; then
    nvim -c "ObsidianNew $2"
  elif [ "$1" = "d" ]; then
    nvim -c "ObsidianDailies"
  else
    l "$HOME/notes/$1"
  fi
}
alias nn='n n'
alias nd='n d'
alias no='n o'
alias obsidian='nvim ~/notes'
alias inbox='l ~/notes/inbox/ && cd ~/notes/inbox/'
alias dg='l ~/notes/digital_garden/ && cd ~/notes/digital_garden/'
alias journal='l ~/notes/journal/ && cd ~/notes/journal/'
alias uni='l ~/notes/universidad/cursos/ && cd ~/notes/universidad/cursos/'
# Buscador fzf inteligente
fif() {
  if [ ! "$#" -gt 0 ]; then
    echo "Need a string to search for!"
    return 1
  fi
  rg --files-with-matches --no-messages "./$1" | fzf --preview "rg --ignore-case --pretty --context 10 '$1' {}"
}
