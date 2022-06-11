
LYNS_STATICHG_BRANCH_SHOW="${LYNS_STATICHG_BRANCH_SHOW=true}"
LYNS_STATICHG_BRANCH_PREFIX="${LYNS_STATICHG_BRANCH_PREFIX="$LYNS_STATICHG_SYMBOL"}"
LYNS_STATICHG_BRANCH_SUFFIX="${LYNS_STATICHG_BRANCH_SUFFIX=""}"
LYNS_STATICHG_BRANCH_COLOR="${LYNS_STATICHG_BRANCH_COLOR="magenta"}"

_lyns_hg_branch() {
  [[ $LYNS_STATICHG_BRANCH_SHOW == false ]] && return

  asyncs::is_hg || return

  local hg_info=$(hg log -r . --template '{activebookmark}')

  if [[ -z $hg_info ]]; then
    hg_info=$(hg branch)
  fi

  asyncs::section \
    "$LYNS_STATICHG_BRANCH_COLOR" \
    "$LYNS_STATICHG_BRANCH_PREFIX"$hg_info"$LYNS_STATICHG_BRANCH_SUFFIX"
}
