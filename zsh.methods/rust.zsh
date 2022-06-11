
LYNS_STATICRUST_SHOW="${LYNS_STATICRUST_SHOW=true}"
LYNS_STATICRUST_PREFIX="${LYNS_STATICRUST_PREFIX="$LYNS_QUERY_DEFAULT_PREFIX"}"
LYNS_STATICRUST_SUFFIX="${LYNS_STATICRUST_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICRUST_SYMBOL="${LYNS_STATICRUST_SYMBOL="🦀 "}"
LYNS_STATICRUST_COLOR="${LYNS_STATICRUST_COLOR="red"}"
LYNS_STATICRUST_VERBOSE_VERSION="${LYNS_STATICRUST_VERBOSE_VERSION=false}"

_lyns_rust() {
  [[ $LYNS_STATICRUST_SHOW == false ]] && return
  
  [[ -f Cargo.toml || -n *.rs(

  asyncs::exists rustc || return

  local rust_version=$(rustc --version | cut -d' ' -f2)

  if [[ $LYNS_STATICRUST_VERBOSE_VERSION == false ]]; then
  	local rust_version=$(echo $rust_version | cut -d'-' -f1) 
  fi

  asyncs::section \
    "$LYNS_STATICRUST_COLOR" \
    "$LYNS_STATICRUST_PREFIX" \
    "${LYNS_STATICRUST_SYMBOL}v${rust_version}" \
    "$LYNS_STATICRUST_SUFFIX"
}
