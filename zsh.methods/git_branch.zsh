
LYNS_STATICGIT_BRANCH_SHOW="${LYNS_STATICGIT_BRANCH_SHOW=true}"
LYNS_STATICGIT_BRANCH_PREFIX="${LYNS_STATICGIT_BRANCH_PREFIX="$LYNS_STATICGIT_SYMBOL"}"
LYNS_STATICGIT_BRANCH_SUFFIX="${LYNS_STATICGIT_BRANCH_SUFFIX=""}"
LYNS_STATICGIT_BRANCH_COLOR="${LYNS_STATICGIT_BRANCH_COLOR="magenta"}"

_lyns_git_branch() {
  [[ $LYNS_STATICGIT_BRANCH_SHOW == false ]] && return

  local git_current_branch="$vcs_info_msg_0_"
  [[ -z "$git_current_branch" ]] && return

  git_current_branch="${git_current_branch
  git_current_branch="${git_current_branch/.../}"

  asyncs::section \
    "$LYNS_STATICGIT_BRANCH_COLOR" \
    "$LYNS_STATICGIT_BRANCH_PREFIX${git_current_branch}$LYNS_STATICGIT_BRANCH_SUFFIX"
}
