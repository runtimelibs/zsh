
LYNS_STATICELM_SHOW="${LYNS_STATICELM_SHOW=true}"
LYNS_STATICELM_PREFIX="${LYNS_STATICELM_PREFIX="$LYNS_QUERY_DEFAULT_PREFIX"}"
LYNS_STATICELM_SUFFIX="${LYNS_STATICELM_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICELM_SYMBOL="${LYNS_STATICELM_SYMBOL="🌳 "}"
LYNS_STATICELM_COLOR="${LYNS_STATICELM_COLOR="cyan"}"

_lyns_elm() {
  [[ $LYNS_STATICELM_SHOW == false ]] && return

  [[ -f elm.json || -f elm-package.json || -d elm-stuff || -n *.elm(

  asyncs::exists elm || return

  local elm_version=$(elm --version 2> /dev/null)

  asyncs::section \
    "$LYNS_STATICELM_COLOR" \
    "$LYNS_STATICELM_PREFIX" \
    "${LYNS_STATICELM_SYMBOL}v${elm_version}" \
    "$LYNS_STATICELM_SUFFIX"
}
