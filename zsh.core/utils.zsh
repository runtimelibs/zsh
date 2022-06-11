
asyncs::exists() {
  command -v $1 > /dev/null 2>&1
}

asyncs::defined() {
  typeset -f + "$1" &> /dev/null
}

asyncs::is_git() {
  
  [[ $(command git rev-parse --is-inside-work-tree 2>/dev/null) == true ]]
}

asyncs::is_hg() {
  local root="$(pwd -P)"

  while [ "$root" ] && [ ! -d "$root/.hg" ]; do
    root="${root%/*}"
  done

  [[ -n "$root" ]] &>/dev/null
}

asyncs::deprecated() {
  [[ -n $1 ]] || return
  local deprecated=$1 message=$2
  local deprecated_value=${(P)deprecated} 
  [[ -n $deprecated_value ]] || return
  print -P "%{%B%}$deprecated%{%b%} is deprecated. $message"
}

asyncs::displaytime() {
  local T=$1
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))
  [[ $D > 0 ]] && printf '%dd ' $D
  [[ $H > 0 ]] && printf '%dh ' $H
  [[ $M > 0 ]] && printf '%dm ' $M
  printf '%ds' $S
}

asyncs::union() {
  typeset -U sections=("$@")
  echo $sections
}
