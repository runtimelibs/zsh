
LYNS_STATICHASKELL_SHOW="${LYNS_STATICHASKELL_SHOW=true}"
LYNS_STATICHASKELL_PREFIX="${LYNS_STATICHASKELL_PREFIX="$LYNS_QUERY_DEFAULT_PREFIX"}"
LYNS_STATICHASKELL_SUFFIX="${LYNS_STATICHASKELL_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICHASKELL_SYMBOL="${LYNS_STATICHASKELL_SYMBOL="λ "}"
LYNS_STATICHASKELL_COLOR="${LYNS_STATICHASKELL_COLOR="red"}"

_lyns_haskell() {
  [[ $LYNS_STATICHASKELL_SHOW == false ]] && return

  
  [[ -f stack.yaml ]] || return

  
  asyncs::exists stack || return

  local haskell_version=$(stack ghc -- --numeric-version --no-install-ghc)

  asyncs::section \
    "$LYNS_STATICHASKELL_COLOR" \
    "$LYNS_STATICHASKELL_PREFIX" \
    "${LYNS_STATICHASKELL_SYMBOL}v${haskell_version}" \
    "$LYNS_STATICHASKELL_SUFFIX"
}
