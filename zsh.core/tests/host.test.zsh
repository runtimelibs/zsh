
setopt shwordsplit
SHUNIT_PARENT=$0

oneTimeSetUp() {
  export TERM="xterm-256color"

  LYNS_QUERY_FIRST_PREFIX_SHOW=true
  LYNS_QUERY_ADD_NEWLINE=false
  LYNS_QUERY_ORDER=(host)

  source asyncs.zsh
}

setUp() {
  LYNS_STATICHOST_SHOW=true
  LYNS_STATICHOST_SHOW_FULL=false
  LYNS_STATICHOST_PREFIX="at "
  LYNS_STATICHOST_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"
  LYNS_STATICHOST_COLOR="blue"
  LYNS_STATICHOST_COLOR_SSH="green"
}

oneTimeTearDown() {
  unset LYNS_QUERY_FIRST_PREFIX_SHOW
  unset LYNS_QUERY_ADD_NEWLINE
  unset LYNS_QUERY_ORDER
}

tearDown() {
  unset LYNS_STATICHOST_SHOW
  unset LYNS_STATICHOST_SHOW_FULL
  unset LYNS_STATICHOST_PREFIX
  unset LYNS_STATICHOST_SUFFIX
  unset LYNS_STATICHOST_COLOR
  unset LYNS_STATICHOST_COLOR_SSH
}

test_host() {
  LYNS_STATICHOST_SHOW=true
  unset SSH_CONNECTION
  assertEquals "do not render host by default" "" "$(_lyns_query*)"
}

test_host_show() {
  local expected="%{%B%}at %{%b%}%{%B%F{$LYNS_STATICHOST_COLOR}%}%m%{%b%f%}%{%B%} %{%b%}"
  local expected_full="%{%B%}at %{%b%}%{%B%F{$LYNS_STATICHOST_COLOR}%}%M%{%b%f%}%{%B%} %{%b%}"
  local expected_ssh="%{%B%}at %{%b%}%{%B%F{$LYNS_STATICHOST_COLOR_SSH}%}%m%{%b%f%}%{%B%} %{%b%}"
  local expected_ssh_full="%{%B%}at %{%b%}%{%B%F{$LYNS_STATICHOST_COLOR_SSH}%}%M%{%b%f%}%{%B%} %{%b%}"

  LYNS_STATICHOST_SHOW=true

  SSH_CONNECTION=''
  LYNS_STATICHOST_SHOW_FULL=false
  assertEquals "SHOW=true, SSH=false, FULL=false" "" "$(_lyns_query*)"
  LYNS_STATICHOST_SHOW_FULL=true
  assertEquals "SHOW=true, SSH=false, FULL=true" "" "$(_lyns_query*)"

  SSH_CONNECTION='ssh'
  LYNS_STATICHOST_SHOW_FULL=false
  assertEquals "SHOW=true, SSH=true, FULL=false" "$expected_ssh" "$(_lyns_query*)"
  LYNS_STATICHOST_SHOW_FULL=true
  assertEquals "SHOW=true, SSH=true, FULL=true" "$expected_ssh_full" "$(_lyns_query*)"

  LYNS_STATICHOST_SHOW=always

  SSH_CONNECTION='ssh'
  LYNS_STATICHOST_SHOW_FULL=false
  assertEquals "SHOW=always, SSH=true, FULL=false" "$expected_ssh" "$(_lyns_query*)"
  LYNS_STATICHOST_SHOW_FULL=true
  assertEquals "SHOW=always, SSH=true, FULL=true" "$expected_ssh_full" "$(_lyns_query*)"

  SSH_CONNECTION=''
  LYNS_STATICHOST_SHOW_FULL=false
  assertEquals "SHOW=always, SSH=false, FULL=false" "$expected" "$(_lyns_query*)"
  LYNS_STATICHOST_SHOW_FULL=true
  assertEquals "SHOW=always, SSH=false, FULL=true" "$expected_full" "$(_lyns_query*)"

  LYNS_STATICHOST_SHOW=false

  SSH_CONNECTION='ssh'
  LYNS_STATICHOST_SHOW_FULL=false
  assertEquals "SHOW=false, SSH=true, FULL=false" "" "$(_lyns_query*)"
  LYNS_STATICHOST_SHOW_FULL=true
  assertEquals "SHOW=false, SSH=true, FULL=true" "" "$(_lyns_query*)"

  SSH_CONNECTION=''
  LYNS_STATICHOST_SHOW_FULL=false
  assertEquals "SHOW=false, SSH=false, FULL=false" "" "$(_lyns_query*)"
  LYNS_STATICHOST_SHOW_FULL=true
  assertEquals "SHOW=false, SSH=false, FULL=true" "" "$(_lyns_query*)"

  unset LYNS_STATICHOST_SHOW_FULL
  unset SSH_CONNECTION
}

test_host_color() {
  LYNS_STATICHOST_SHOW=always 
  LYNS_STATICHOST_COLOR=blue

  local expected="%{%B%}at %{%b%}%{%B%F{$LYNS_STATICHOST_COLOR}%}%m%{%b%f%}%{%B%} %{%b%}"
  local actual="$(_lyns_query*)"

  assertEquals "render host with custom color" "$expected" "$actual"
}

test_host_prefix() {
  LYNS_STATICHOST_SHOW=always 
  LYNS_STATICHOST_PREFIX='prefix'
  LYNS_STATICHOST_SUFFIX=''

  local expected="%{%B%}$LYNS_STATICHOST_PREFIX%{%b%}%{%B%F{blue}%}%m%{%b%f%}%{%B%}$LYNS_STATICHOST_SUFFIX%{%b%}"
  local actual="$(_lyns_query*)"

  assertEquals "render host with prefix" "$expected" "$actual"
}

test_host_suffix() {
  LYNS_STATICHOST_SHOW=always 
  LYNS_STATICHOST_PREFIX=''
  LYNS_STATICHOST_SUFFIX='suffix'

  local expected="%{%B%}$LYNS_STATICHOST_PREFIX%{%b%}%{%B%F{blue}%}%m%{%b%f%}%{%B%}$LYNS_STATICHOST_SUFFIX%{%b%}"
  local actual="$(_lyns_query*)"

  assertEquals "render host with suffix" "$expected" "$actual"
}






source tests/shunit2/shunit2
