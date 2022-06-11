#!/usr/bin/env zsh
_lyns_exec_time_preexec_hook() {
  [[ $LYNS_STATICEXEC_TIME_SHOW == false ]] && return
  LYNS_STATICEXEC_TIME_start=$(date +%s)
}

_lyns_exec_time_precmd_hook() {
  [[ $LYNS_STATICEXEC_TIME_SHOW == false ]] && return
  [[ -n $LYNS_STATICEXEC_TIME_duration ]] && unset LYNS_STATICEXEC_TIME_duration
  [[ -z $LYNS_STATICEXEC_TIME_start ]] && return
  local LYNS_STATICEXEC_TIME_stop=$(date +%s)
  LYNS_STATICEXEC_TIME_duration=$(( $LYNS_STATICEXEC_TIME_stop - $LYNS_STATICEXEC_TIME_start ))
  unset LYNS_STATICEXEC_TIME_start
}

_lyns_exec_vcs_info_precmd_hook() {
  [[ $LYNS_STATICGIT_BRANCH_SHOW == false ]] && return
  vcs_info
}
