
LYNS_STATICELIXIR_SHOW="${LYNS_STATICELIXIR_SHOW=true}"
LYNS_STATICELIXIR_PREFIX="${LYNS_STATICELIXIR_PREFIX="$LYNS_QUERY_DEFAULT_PREFIX"}"
LYNS_STATICELIXIR_SUFFIX="${LYNS_STATICELIXIR_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICELIXIR_SYMBOL="${LYNS_STATICELIXIR_SYMBOL="💧 "}"
LYNS_STATICELIXIR_DEFAULT_VERSION="${LYNS_STATICELIXIR_DEFAULT_VERSION=""}"
LYNS_STATICELIXIR_COLOR="${LYNS_STATICELIXIR_COLOR="magenta"}"

_lyns_elixir() {
  [[ $LYNS_STATICELIXIR_SHOW == false ]] && return

  
  [[ -f mix.exs || -n *.ex(

  local 'elixir_version'

  if asyncs::exists kiex; then
    elixir_version="${ELIXIR_VERSION}"
  elif asyncs::exists exenv; then
    elixir_version=$(exenv version-name)
  fi

  if [[ $elixir_version == "" ]]; then
    asyncs::exists elixir || return
    elixir_version=$(elixir -v 2>/dev/null | grep "Elixir" --color=never | cut -d ' ' -f 2)
  fi

  [[ $elixir_version == "system" ]] && return
  [[ $elixir_version == $LYNS_STATICELIXIR_DEFAULT_VERSION ]] && return

  
  [[ "${elixir_version}" =~ ^[0-9].+$ ]] && elixir_version="v${elixir_version}"

  asyncs::section \
    "$LYNS_STATICELIXIR_COLOR" \
    "$LYNS_STATICELIXIR_PREFIX" \
    "${LYNS_STATICELIXIR_SYMBOL}${elixir_version}" \
    "$LYNS_STATICELIXIR_SUFFIX"
}
