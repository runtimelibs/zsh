
LYNS_STATICGOLANG_SHOW="${LYNS_STATICGOLANG_SHOW=true}"
LYNS_STATICGOLANG_PREFIX="${LYNS_STATICGOLANG_PREFIX="$LYNS_QUERY_DEFAULT_PREFIX"}"
LYNS_STATICGOLANG_SUFFIX="${LYNS_STATICGOLANG_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICGOLANG_SYMBOL="${LYNS_STATICGOLANG_SYMBOL="🐹 "}"
LYNS_STATICGOLANG_COLOR="${LYNS_STATICGOLANG_COLOR="cyan"}"

_lyns_golang() {
  [[ $LYNS_STATICGOLANG_SHOW == false ]] && return

  
  [[ -f go.mod || -d Godeps || -f glide.yaml || -n *.go(
  || ( $GOPATH && "$PWD/" =~ "$GOPATH/" ) ]] || return

  asyncs::exists go || return
  local go_version=$(go version | awk '{ if ($3 ~ /^devel/) {print $3 ":" substr($4, 2)} else {print "v" substr($3, 3)} }')

  asyncs::section \
    "$LYNS_STATICGOLANG_COLOR" \
    "$LYNS_STATICGOLANG_PREFIX" \
    "${LYNS_STATICGOLANG_SYMBOL}${go_version}" \
    "$LYNS_STATICGOLANG_SUFFIX"
}
