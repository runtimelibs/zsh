
setopt shwordsplit
SHUNIT_PARENT=$0

oneTimeSetUp() {
  export TERM="xterm-256color"

  source lib/hooks.zsh
}

setUp() {
  LYNS_STATICEXEC_TIME_SHOW=true
  LYNS_STATICGIT_BRANCH_SHOW=true
}

tearDown() {
  unset LYNS_STATICEXEC_TIME_SHOW
  unset LYNS_STATICGIT_BRANCH_SHOW
}

test_exec_time_preexec_hook() {
  local date_mock='123456'
  date() { echo -n $date_mock }

  local expected="$date_mock"

  
  _lyns_exec_time_preexec_hook

  assertEquals "should save starting time" "$date_mock" "$LYNS_STATICEXEC_TIME_start"

  unset LYNS_STATICEXEC_TIME_start

  LYNS_STATICEXEC_TIME_SHOW=false
  _lyns_exec_time_preexec_hook
  assertNull "should not call hook" "$LYNS_STATICEXEC_TIME_start"
}

test_exec_time_precmd_hook() {
  local date_start_mock='123'
  local date_stop_mock='321'
  local date_duration_mock='198'
  date() { echo -n $date_stop_mock }

  LYNS_STATICEXEC_TIME_start="$date_start_mock"

  _lyns_exec_time_precmd_hook
  assertEquals "should calculate duration" "$date_duration_mock" "$LYNS_STATICEXEC_TIME_duration"
  assertNull "$LYNS_STATICEXEC_TIME_start"

  _lyns_exec_time_precmd_hook
  assertNull "should not calculate without starting time" "$LYNS_STATICEXEC_TIME_duration"

  LYNS_STATICEXEC_TIME_SHOW=false
  LYNS_STATICEXEC_TIME_start="$date_start_mock"
  _lyns_exec_time_precmd_hook
  assertNull "should not calculate duration" "$LYNS_STATICEXEC_TIME_duration"
}

test_exec_vcs_info_precmd_hook() {
  local info_mock="vcs_info"
  vcs_info() { echo -n $info_mock }

  local expected="$info_mock"
  local actual="$(_lyns_exec_vcs_info_precmd_hook)"

  assertEquals "call vcs_info" "$expected" "$actual"

  LYNS_STATICGIT_BRANCH_SHOW=false
  local expected_skip=""
  local actual_skip="$(_lyns_exec_vcs_info_precmd_hook)"

  assertEquals "should not call vcs_info hook" "$expected_skip" "$actual_skip"
}

source tests/shunit2/shunit2
