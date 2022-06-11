#!/usr/bin/env zsh

if [[ ! -z $(which tput 2> /dev/null) ]]; then
  reset=$(tput sgr0)
  bold=$(tput bold)
  red=$(tput setaf 1)
  green=$(tput setaf 2)
  yellow=$(tput setaf 3)
  blue=$(tput setaf 4)
  magenta=$(tput setaf 5)
  cyan=$(tput setaf 6)
fi

ZSHRC="~/.zshrc"
REPO='git@github.com:ztasec/ztasec.shell.config.dev.git'
SOURCE="~/.config/dependencies.zsh"
USER_SOURCE="~/.config"
DEST='/usr/local/share/zsh/site-functions'
USER_DEST="~/.zfunctions"

paint() {
  local color=$1 rest=${@:2}
  echo "$color$rest$reset"
}
info()    { paint "$cyan"   "LYNS: $@" ; }
warn()    { paint "$yellow" "LYNS: $@" ; }
error()   { paint "$red"    "LYNS: $@" ; }
success() { paint "$green"  "LYNS: $@" ; }
code()    { paint "$bold"   "LYNS: $@" ; }

main() {
  
  if [[ ! -f "$SOURCE" ]]; then
    warn "Lyns cannot be located in its current location."
  #  git clone "$REPO" "$USER_SOURCE"
  else
    info "Lyns is present and functional..."
  fi
}

main "$@"zsh --version
