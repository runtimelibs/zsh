
LYNS_STATICNODE_SHOW="${LYNS_STATICNODE_SHOW=true}"
LYNS_STATICNODE_PREFIX="${LYNS_STATICNODE_PREFIX="$LYNS_QUERY_DEFAULT_PREFIX"}"
LYNS_STATICNODE_SUFFIX="${LYNS_STATICNODE_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICNODE_SYMBOL="${LYNS_STATICNODE_SYMBOL="⬢ "}"
LYNS_STATICNODE_DEFAULT_VERSION="${LYNS_STATICNODE_DEFAULT_VERSION=""}"
LYNS_STATICNODE_COLOR="${LYNS_STATICNODE_COLOR="green"}"

_lyns_node() {
  [[ $LYNS_STATICNODE_SHOW == false ]] && return
  
  [[ -f package.json || -d node_modules || -n *.js(

  local 'node_version'

  if asyncs::exists fnm; then
    node_version=$(fnm current 2>/dev/null)
    [[ $node_version == "system" || $node_version == "node" ]] && return
  elif asyncs::exists nvm; then
    node_version=$(nvm current 2>/dev/null)
    [[ $node_version == "system" || $node_version == "node" ]] && return
  elif asyncs::exists nodenv; then
    node_version=$(nodenv version-name)
    [[ $node_version == "system" || $node_version == "node" ]] && return
  elif asyncs::exists node; then
    node_version=$(node -v 2>/dev/null)
  else
    return
  fi

  [[ $node_version == $LYNS_STATICNODE_DEFAULT_VERSION ]] && return

  asyncs::section \
    "$LYNS_STATICNODE_COLOR" \
    "$LYNS_STATICNODE_PREFIX" \
    "${LYNS_STATICNODE_SYMBOL}${node_version}" \
    "$LYNS_STATICNODE_SUFFIX"
}
