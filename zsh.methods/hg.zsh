
LYNS_STATICHG_SHOW="${LYNS_STATICHG_SHOW=true}"
LYNS_STATICHG_PREFIX="${LYNS_STATICHG_PREFIX="on "}"
LYNS_STATICHG_SUFFIX="${LYNS_STATICHG_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICHG_SYMBOL="${LYNS_STATICHG_SYMBOL="☿ "}"

source "$LYNS_STATICROOT/sections/hg_branch.zsh"
source "$LYNS_STATICROOT/sections/hg_status.zsh"

_lyns_hg() {
  [[ $LYNS_STATICHG_SHOW == false ]] && return

  local hg_branch="$(_lyns_hg_branch)" hg_status="$(_lyns_hg_status)"

  [[ -z $hg_branch ]] && return

  asyncs::section \
    'white' \
    "$LYNS_STATICHG_PREFIX" \
    "${hg_branch}${hg_status}" \
    "$LYNS_STATICHG_SUFFIX"
}
