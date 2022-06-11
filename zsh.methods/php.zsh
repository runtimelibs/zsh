
LYNS_STATICPHP_SHOW="${LYNS_STATICPHP_SHOW=true}"
LYNS_STATICPHP_PREFIX="${LYNS_STATICPHP_PREFIX="$LYNS_QUERY_DEFAULT_PREFIX"}"
LYNS_STATICPHP_SUFFIX="${LYNS_STATICPHP_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICPHP_SYMBOL="${LYNS_STATICPHP_SYMBOL="🐘 "}"
LYNS_STATICPHP_COLOR="${LYNS_STATICPHP_COLOR="blue"}"

_lyns_php() {
  [[ $LYNS_STATICPHP_SHOW == false ]] && return
  
  [[ -n *.php(

  asyncs::exists php || return

  local php_version=$(php -v 2>&1 | \grep --color=never -oe "^PHP\s*[0-9.]\+" | awk '{print $2}')

  asyncs::section \
    "$LYNS_STATICPHP_COLOR" \
    "$LYNS_STATICPHP_PREFIX" \
    "${LYNS_STATICPHP_SYMBOL}v${php_version}" \
    "${LYNS_STATICPHP_SUFFIX}"
}
