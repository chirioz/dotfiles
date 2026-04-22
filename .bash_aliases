# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='eza -F --group-directories-first --sort=modified --icons=auto --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
fi

# My alaiases
# List files and directories
alias ll='eza -lhgF --group-directories-first --sort=modified --icons=auto'
alias la='eza -alhgF --group-directories-first --sort=modified --icons=auto'
alias l='eza -F -1 --group-directories-first --sort=modified --icons=auto'
alias tree='eza -T --icons=auto'

# Hledger
alias hbudget='hledger bal --budget -p weekly from 2026-02-19 -W --change --no-total --auto --tree'
alias hbudgetr='hledger bal --budget -p weekly from 2026-02-19 -W --change --no-total --tree'
alias registro='git -C ~/finance/hledger pull --rebase && hledger add && ~/finance/hledger/sync_finance.sh'
alias hdashboard='/home/fchairezd/finance/hledger/dashboard.sh'

# Bashrc
alias bashrc='nvim ~/.bashrc'
alias loadbash='source ~/.bashrc'

# Utilidad
alias cat='bat'
alias cls='clear'
alias rm='echo Este no es el comando que buscas. Prueba trashput o \\rm.; false'
alias clima="curl 'Accept-Language: es' wttr.in/CiudadJuarez?F?T"

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
