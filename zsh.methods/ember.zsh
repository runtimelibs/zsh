
LYNS_STATICEMBER_SHOW="${LYNS_STATICEMBER_SHOW=true}"
LYNS_STATICEMBER_PREFIX="${LYNS_STATICEMBER_PREFIX="$LYNS_QUERY_DEFAULT_PREFIX"}"
LYNS_STATICEMBER_SUFFIX="${LYNS_STATICEMBER_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICEMBER_SYMBOL="${LYNS_STATICEMBER_SYMBOL="🐹 "}"
LYNS_STATICEMBER_COLOR="${LYNS_STATICEMBER_COLOR="210"}"

_lyns_ember() {
  [[ $LYNS_STATICEMBER_SHOW == false ]] && return

  
  [[ -f ember-cli-build.js && -f node_modules/ember-cli/package.json ]] || return

  local ember_version=$(grep '"version":' ./node_modules/ember-cli/package.json | cut -d\" -f4)
  [[ $ember_version == "system" || $ember_version == "ember" ]] && return

  asyncs::section \
    "$LYNS_STATICEMBER_COLOR" \
    "$LYNS_STATICEMBER_PREFIX" \
    "${LYNS_STATICEMBER_SYMBOL}${ember_version}" \
    "$LYNS_STATICEMBER_SUFFIX"
}
