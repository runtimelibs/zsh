
LYNS_STATICGIT_STATUS_SHOW="${LYNS_STATICGIT_STATUS_SHOW=true}"
LYNS_STATICGIT_STATUS_PREFIX="${LYNS_STATICGIT_STATUS_PREFIX=" ["}"
LYNS_STATICGIT_STATUS_SUFFIX="${LYNS_STATICGIT_STATUS_SUFFIX="]"}"
LYNS_STATICGIT_STATUS_COLOR="${LYNS_STATICGIT_STATUS_COLOR="red"}"
LYNS_STATICGIT_STATUS_UNTRACKED="${LYNS_STATICGIT_STATUS_UNTRACKED="?"}"
LYNS_STATICGIT_STATUS_ADDED="${LYNS_STATICGIT_STATUS_ADDED="+"}"
LYNS_STATICGIT_STATUS_MODIFIED="${LYNS_STATICGIT_STATUS_MODIFIED="!"}"
LYNS_STATICGIT_STATUS_RENAMED="${LYNS_STATICGIT_STATUS_RENAMED="»"}"
LYNS_STATICGIT_STATUS_DELETED="${LYNS_STATICGIT_STATUS_DELETED="✘"}"
LYNS_STATICGIT_STATUS_STASHED="${LYNS_STATICGIT_STATUS_STASHED="$"}"
LYNS_STATICGIT_STATUS_UNMERGED="${LYNS_STATICGIT_STATUS_UNMERGED="="}"
LYNS_STATICGIT_STATUS_AHEAD="${LYNS_STATICGIT_STATUS_AHEAD="⇡"}"
LYNS_STATICGIT_STATUS_BEHIND="${LYNS_STATICGIT_STATUS_BEHIND="⇣"}"
LYNS_STATICGIT_STATUS_DIVERGED="${LYNS_STATICGIT_STATUS_DIVERGED="⇕"}"

_lyns_git_status() {
  [[ $LYNS_STATICGIT_STATUS_SHOW == false ]] && return

  asyncs::is_git || return

  local INDEX git_status=""

  INDEX=$(command git status --porcelain -b 2> /dev/null)

  
  if $(echo "$INDEX" | command grep -E '^\?\? ' &> /dev/null); then
    git_status="$LYNS_STATICGIT_STATUS_UNTRACKED$git_status"
  fi

  
  if $(echo "$INDEX" | command grep '^A[ MDAU] ' &> /dev/null); then
    git_status="$LYNS_STATICGIT_STATUS_ADDED$git_status"
  elif $(echo "$INDEX" | command grep '^M[ MD] ' &> /dev/null); then
    git_status="$LYNS_STATICGIT_STATUS_ADDED$git_status"
  elif $(echo "$INDEX" | command grep '^UA' &> /dev/null); then
    git_status="$LYNS_STATICGIT_STATUS_ADDED$git_status"
  fi

  
  if $(echo "$INDEX" | command grep '^[ MARC]M ' &> /dev/null); then
    git_status="$LYNS_STATICGIT_STATUS_MODIFIED$git_status"
  fi

  
  if $(echo "$INDEX" | command grep '^R[ MD] ' &> /dev/null); then
    git_status="$LYNS_STATICGIT_STATUS_RENAMED$git_status"
  fi

  
  if $(echo "$INDEX" | command grep '^[MARCDU ]D ' &> /dev/null); then
    git_status="$LYNS_STATICGIT_STATUS_DELETED$git_status"
  elif $(echo "$INDEX" | command grep '^D[ UM] ' &> /dev/null); then
    git_status="$LYNS_STATICGIT_STATUS_DELETED$git_status"
  fi

  
  if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
    git_status="$LYNS_STATICGIT_STATUS_STASHED$git_status"
  fi

  
  if $(echo "$INDEX" | command grep '^U[UDA] ' &> /dev/null); then
    git_status="$LYNS_STATICGIT_STATUS_UNMERGED$git_status"
  elif $(echo "$INDEX" | command grep '^AA ' &> /dev/null); then
    git_status="$LYNS_STATICGIT_STATUS_UNMERGED$git_status"
  elif $(echo "$INDEX" | command grep '^DD ' &> /dev/null); then
    git_status="$LYNS_STATICGIT_STATUS_UNMERGED$git_status"
  elif $(echo "$INDEX" | command grep '^[DA]U ' &> /dev/null); then
    git_status="$LYNS_STATICGIT_STATUS_UNMERGED$git_status"
  fi

  
  local is_ahead=false
  if $(echo "$INDEX" | command grep '^
    is_ahead=true
  fi

  
  local is_behind=false
  if $(echo "$INDEX" | command grep '^
    is_behind=true
  fi

  
  if [[ "$is_ahead" == true && "$is_behind" == true ]]; then
    git_status="$LYNS_STATICGIT_STATUS_DIVERGED$git_status"
  else
    [[ "$is_ahead" == true ]] && git_status="$LYNS_STATICGIT_STATUS_AHEAD$git_status"
    [[ "$is_behind" == true ]] && git_status="$LYNS_STATICGIT_STATUS_BEHIND$git_status"
  fi

  if [[ -n $git_status ]]; then
    
    asyncs::section \
      "$LYNS_STATICGIT_STATUS_COLOR" \
      "$LYNS_STATICGIT_STATUS_PREFIX$git_status$LYNS_STATICGIT_STATUS_SUFFIX"
  fi
}
