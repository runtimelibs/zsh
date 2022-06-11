
LYNS_STATICHG_STATUS_SHOW="${LYNS_STATICHG_STATUS_SHOW=true}"
LYNS_STATICHG_STATUS_PREFIX="${LYNS_STATICHG_STATUS_PREFIX=" ["}"
LYNS_STATICHG_STATUS_SUFFIX="${LYNS_STATICHG_STATUS_SUFFIX="]"}"
LYNS_STATICHG_STATUS_COLOR="${LYNS_STATICHG_STATUS_COLOR="red"}"
LYNS_STATICHG_STATUS_UNTRACKED="${LYNS_STATICHG_STATUS_UNTRACKED="?"}"
LYNS_STATICHG_STATUS_ADDED="${LYNS_STATICHG_STATUS_ADDED="+"}"
LYNS_STATICHG_STATUS_MODIFIED="${LYNS_STATICHG_STATUD_MODIFIED="!"}"
LYNS_STATICHG_STATUS_DELETED="${LYNS_STATICHG_STATUS_DELETED="✘"}"

_lyns_hg_status() {
  [[ $LYNS_STATICHG_STATUS_SHOW == false ]] && return

  asyncs::is_hg || return

  local INDEX=$(hg status 2>/dev/null) hg_status=""
  
  if $(echo "$INDEX" | grep -E '^\? ' &> /dev/null); then
    hg_status="$LYNS_STATICHG_STATUS_UNTRACKED$hg_status"
  fi
  if $(echo "$INDEX" | grep -E '^A ' &> /dev/null); then
    hg_status="$LYNS_STATICHG_STATUS_ADDED$hg_status"
  fi
  if $(echo "$INDEX" | grep -E '^M ' &> /dev/null); then
    hg_status="$LYNS_STATICHG_STATUS_MODIFIED$hg_status"
  fi
  if $(echo "$INDEX" | grep -E '^(R|!)' &> /dev/null); then
    hg_status="$LYNS_STATICHG_STATUS_DELETED$hg_status"
  fi
  if [[ -n $hg_status ]]; then
    asyncs::section \
      "$LYNS_STATICHG_STATUS_COLOR" \
      "$LYNS_STATICHG_STATUS_PREFIX"$hg_status"$LYNS_STATICHG_STATUS_SUFFIX"
  fi
}
