
LYNS_STATICGIT_SHOW="${LYNS_STATICGIT_SHOW=true}"
LYNS_STATICGIT_PREFIX="${LYNS_STATICGIT_PREFIX="on "}"
LYNS_STATICGIT_SUFFIX="${LYNS_STATICGIT_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICGIT_SYMBOL="${LYNS_STATICGIT_SYMBOL=" "}"

source "$LYNS_STATICROOT/sections/git_branch.zsh"
source "$LYNS_STATICROOT/sections/git_status.zsh"

_lyns_git() {
  [[ $LYNS_STATICGIT_SHOW == false ]] && return

  local git_branch="$(_lyns_git_branch)" git_status="$(_lyns_git_status)"

  [[ -z $git_branch ]] && return

  asyncs::section \
    'white' \
    "$LYNS_STATICGIT_PREFIX" \
    "${git_branch}${git_status}" \
    "$LYNS_STATICGIT_SUFFIX"
}
