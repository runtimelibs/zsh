
LYNS_STATICDIR_SHOW="${LYNS_STATICDIR_SHOW=true}"
LYNS_STATICDIR_PREFIX="${LYNS_STATICDIR_PREFIX="in "}"
LYNS_STATICDIR_SUFFIX="${LYNS_STATICDIR_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICDIR_TRUNC="${LYNS_STATICDIR_TRUNC=3}"
LYNS_STATICDIR_TRUNC_PREFIX="${LYNS_STATICDIR_TRUNC_PREFIX=}"
LYNS_STATICDIR_TRUNC_REPO="${LYNS_STATICDIR_TRUNC_REPO=true}"
LYNS_STATICDIR_COLOR="${LYNS_STATICDIR_COLOR="cyan"}"
LYNS_STATICDIR_LOCK_SYMBOL="${LYNS_STATICDIR_LOCK_SYMBOL=" "}"
LYNS_STATICDIR_LOCK_COLOR="${LYNS_STATICDIR_LOCK_COLOR="red"}"

_lyns_dir() {
  [[ $LYNS_STATICDIR_SHOW == false ]] && return

  local 'dir' 'trunc_prefix'

  
  if [[ $LYNS_STATICDIR_TRUNC_REPO == true ]] && asyncs::is_git; then
    local git_root=$(git rev-parse --show-toplevel)

    if (cygpath --version) >/dev/null 2>/dev/null; then
      git_root=$(cygpath -u $git_root)
    fi

    
    if [[ $git_root:h == / ]]; then
      trunc_prefix=/
    else
      trunc_prefix=$LYNS_STATICDIR_TRUNC_PREFIX
    fi
    
    dir="$trunc_prefix$git_root:t${${PWD:A}
  else
    if [[ LYNS_STATICDIR_TRUNC -gt 0 ]]; then
      trunc_prefix="%($((LYNS_STATICDIR_TRUNC + 1))~|$LYNS_STATICDIR_TRUNC_PREFIX|)"
    fi

    dir="$trunc_prefix%${LYNS_STATICDIR_TRUNC}~"
  fi

  if [[ ! -w . ]]; then
    LYNS_STATICDIR_SUFFIX="%F{$LYNS_STATICDIR_LOCK_COLOR}${LYNS_STATICDIR_LOCK_SYMBOL}%f${LYNS_STATICDIR_SUFFIX}"
  fi

  asyncs::section \
    "$LYNS_STATICDIR_COLOR" \
    "$LYNS_STATICDIR_PREFIX" \
    "$dir" \
    "$LYNS_STATICDIR_SUFFIX"
}
