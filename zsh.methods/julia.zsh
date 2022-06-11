
LYNS_STATICJULIA_SHOW="${LYNS_STATICJULIA_SHOW=true}"
LYNS_STATICJULIA_PREFIX="${LYNS_STATICJULIA_PREFIX="$LYNS_QUERY_DEFAULT_PREFIX"}"
LYNS_STATICJULIA_SUFFIX="${LYNS_STATICJULIA_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICJULIA_SYMBOL="${LYNS_STATICJULIA_SYMBOL="ஃ "}"
LYNS_STATICJULIA_COLOR="${LYNS_STATICJULIA_COLOR="green"}"

_lyns_julia() {
  [[ $LYNS_STATICJULIA_SHOW == false ]] && return

  
  [[ -n *.jl(

  asyncs::exists julia || return

  local julia_version=$(julia --version | grep --color=never -oE '[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]')

  asyncs::section \
    "$LYNS_STATICJULIA_COLOR" \
    "$LYNS_STATICJULIA_PREFIX" \
    "${LYNS_STATICJULIA_SYMBOL}v${julia_version}" \
    "$LYNS_STATICJULIA_SUFFIX"
}
