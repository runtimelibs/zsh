
LYNS_STATICPYENV_SHOW="${LYNS_STATICPYENV_SHOW=true}"
LYNS_STATICPYENV_PREFIX="${LYNS_STATICPYENV_PREFIX="$LYNS_QUERY_DEFAULT_PREFIX"}"
LYNS_STATICPYENV_SUFFIX="${LYNS_STATICPYENV_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICPYENV_SYMBOL="${LYNS_STATICPYENV_SYMBOL="🐍 "}"
LYNS_STATICPYENV_COLOR="${LYNS_STATICPYENV_COLOR="yellow"}"

_lyns_pyenv() {
  [[ $LYNS_STATICPYENV_SHOW == false ]] && return

  
  [[ -n "$PYENV_VERSION" || -f .python-version || -f requirements.txt || -f pyproject.toml || -n *.py(

  asyncs::exists pyenv || return 

  local pyenv_status=${$(pyenv version-name 2>/dev/null)//:/ }

  asyncs::section \
    "$LYNS_STATICPYENV_COLOR" \
    "$LYNS_STATICPYENV_PREFIX" \
    "${LYNS_STATICPYENV_SYMBOL}${pyenv_status}" \
    "$LYNS_STATICPYENV_SUFFIX"
}
