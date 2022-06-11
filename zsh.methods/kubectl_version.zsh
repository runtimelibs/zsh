
LYNS_STATICKUBECTL_VERSION_SHOW="${LYNS_STATICKUBECTL_VERSION_SHOW=true}"
LYNS_STATICKUBECTL_VERSION_PREFIX="${LYNS_STATICKUBECTL_VERSION_PREFIX=""}"
LYNS_STATICKUBECTL_VERSION_SUFFIX="${LYNS_STATICKUBECTL_VERSION_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICKUBECTL_VERSION_COLOR="${LYNS_STATICKUBECTL_VERSION_COLOR="cyan"}"

_lyns_kubectl_version() {
  [[ $LYNS_STATICKUBECTL_VERSION_SHOW == false ]] && return

  asyncs::exists kubectl || return

  
  local kubectl_version=$(kubectl version --short 2>/dev/null | grep "Server Version" | sed 's/Server Version: \(.*\)/\1/')
  [[ -z $kubectl_version ]] && return

  asyncs::section \
    "$LYNS_STATICKUBECTL_VERSION_COLOR" \
    "$LYNS_STATICKUBECTL_VERSION_PREFIX" \
    "${kubectl_version}" \
    "$LYNS_STATICKUBECTL_VERSION_SUFFIX"
}
