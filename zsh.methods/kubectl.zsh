
LYNS_STATICKUBECTL_SHOW="${LYNS_STATICKUBECTL_SHOW=false}"
LYNS_STATICKUBECTL_PREFIX="${LYNS_STATICKUBECTL_PREFIX="at "}"
LYNS_STATICKUBECTL_SUFFIX="${LYNS_STATICKUBECTL_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICKUBECTL_COLOR="${LYNS_STATICKUBECTL_COLOR="white"}"
LYNS_STATICKUBECTL_SYMBOL="${LYNS_STATICKUBECTL_SYMBOL="☸️  "}"

source "$LYNS_STATICROOT/sections/kubectl_version.zsh"
source "$LYNS_STATICROOT/sections/kubectl_context.zsh"

_lyns_kubectl() {
  [[ $LYNS_STATICKUBECTL_SHOW == false ]] && return

  local kubectl_version="$(_lyns_kubectl_version)" kubectl_context="$(_lyns_kubectl_context)"

  [[ -z $kubectl_version && -z $kubectl_context ]] && return

  asyncs::section \
    "$LYNS_STATICKUBECTL_COLOR" \
    "$LYNS_STATICKUBECTL_PREFIX" \
    "${LYNS_STATICKUBECTL_SYMBOL}${kubectl_version}${kubectl_context}" \
    "$LYNS_STATICKUBECTL_SUFFIX"
}
