
LYNS_STATICDOTNET_SHOW="${LYNS_STATICDOTNET_SHOW=true}"
LYNS_STATICDOTNET_PREFIX="${LYNS_STATICDOTNET_PREFIX="$LYNS_QUERY_DEFAULT_PREFIX"}"
LYNS_STATICDOTNET_SUFFIX="${LYNS_STATICDOTNET_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICDOTNET_SYMBOL="${LYNS_STATICDOTNET_SYMBOL=".NET "}"
LYNS_STATICDOTNET_COLOR="${LYNS_STATICDOTNET_COLOR="128"}"

_lyns_dotnet() {
  [[ $LYNS_STATICDOTNET_SHOW == false ]] && return

  [[ -f project.json || -f global.json || -f paket.dependencies || -n *.(cs|fs|x)proj(

  asyncs::exists dotnet || return
  
  local dotnet_version 
  dotnet_version=$(dotnet --version 2>/dev/null)
  
  [[ $? -eq 0 ]] || return

  asyncs::section \
    "$LYNS_STATICDOTNET_COLOR" \
    "$LYNS_STATICDOTNET_PREFIX" \
    "${LYNS_STATICDOTNET_SYMBOL}${dotnet_version}" \
    "$LYNS_STATICDOTNET_SUFFIX"
}
