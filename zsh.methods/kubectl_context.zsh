

LYNS_STATICKUBECONTEXT_SHOW="${LYNS_STATICKUBECONTEXT_SHOW=true}"
LYNS_STATICKUBECONTEXT_PREFIX="${LYNS_STATICKUBECONTEXT_PREFIX=""}"
LYNS_STATICKUBECONTEXT_SUFFIX="${LYNS_STATICKUBECONTEXT_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICKUBECONTEXT_COLOR="${LYNS_STATICKUBECONTEXT_COLOR="cyan"}"
LYNS_STATICKUBECONTEXT_NAMESPACE_SHOW="${LYNS_STATICKUBECONTEXT_NAMESPACE_SHOW=true}"
LYNS_STATICKUBECONTEXT_COLOR_GROUPS=(${LYNS_STATICKUBECONTEXT_COLOR_GROUPS=})

_lyns_kubectl_context() {
  [[ $LYNS_STATICKUBECONTEXT_SHOW == false ]] && return

  asyncs::exists kubectl || return

  local kube_context=$(kubectl config current-context 2>/dev/null)
  [[ -z $kube_context ]] && return

  if [[ $LYNS_STATICKUBECONTEXT_NAMESPACE_SHOW == true ]]; then
    local kube_namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
    [[ -n $kube_namespace && "$kube_namespace" != "default" ]] && kube_context="$kube_context ($kube_namespace)"
  fi
  
  local len=${
  local it_to=$((len / 2))
  local 'section_color' 'i'
  for ((i = 1; i <= $it_to; i++)); do
    local idx=$(((i - 1) * 2))
    local color="${LYNS_STATICKUBECONTEXT_COLOR_GROUPS[$idx + 1]}"
    local pattern="${LYNS_STATICKUBECONTEXT_COLOR_GROUPS[$idx + 2]}"
    if [[ "$kube_context" =~ "$pattern" ]]; then
      section_color=$color
      break
    fi
  done

  [[ -z "$section_color" ]] && section_color=$LYNS_STATICKUBECONTEXT_COLOR

  asyncs::section \
    "$section_color" \
    "$LYNS_STATICKUBECONTEXT_PREFIX" \
    "${kube_context}" \
    "$LYNS_STATICKUBECONTEXT_SUFFIX"
}
