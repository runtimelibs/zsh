
setopt shwordsplit
SHUNIT_PARENT=$0

oneTimeSetUp() {
  export TERM="xterm-256color"

  LYNS_QUERY_ADD_NEWLINE=false
  LYNS_QUERY_FIRST_PREFIX_SHOW=true
  LYNS_QUERY_ORDER=(user)

  source asyncs.zsh
}

setUp() {
  LYNS_STATICUSER_SHOW=true
  LYNS_STATICUSER_PREFIX="with "
  LYNS_STATICUSER_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"
  LYNS_STATICUSER_COLOR="yellow"
  LYNS_STATICUSER_COLOR_ROOT="red"
}

oneTimeTearDown() {
  unset LYNS_QUERY_FIRST_PREFIX_SHOW
  unset LYNS_QUERY_ADD_NEWLINE
  unset LYNS_QUERY_ORDER
}

tearDown() {
  unset LYNS_STATICUSER_SHOW
  unset LYNS_STATICUSER_PREFIX
  unset LYNS_STATICUSER_SUFFIX
  unset LYNS_STATICUSER_COLOR
  unset LYNS_STATICUSER_COLOR_ROOT
}

test_user() {
  local _user_="$USER"
  USER='tests'

  local expected="%{%B%}with %{%b%}%{%B%F{yellow}%}%n%{%b%f%}%{%B%} %{%b%}"
  local actual="$(_lyns_query*)"

  assertEquals "render user when needed" "$expected" "$actual"

  USER=$_user_
}

test_user_show() {
  local expected="%{%B%}with %{%b%}%{%B%F{yellow}%}%n%{%b%f%}%{%B%} %{%b%}"

  LYNS_STATICUSER_SHOW=true
  SSH_CONNECTION=''
  assertEquals "SHOW=true, SSH=false" "" "$(_lyns_query*)"
  SSH_CONNECTION='ssh'
  assertEquals "SHOW=true, SSH=true" "$expected" "$(_lyns_query*)"

  LYNS_STATICUSER_SHOW=always
  SSH_CONNECTION=''
  assertEquals "SHOW=always, SSH=false" "$expected" "$(_lyns_query*)"
  SSH_CONNECTION='ssh'
  assertEquals "SHOW=always, SSH=true" "$expected" "$(_lyns_query*)"

  LYNS_STATICUSER_SHOW=false
  SSH_CONNECTION=''
  assertEquals "SHOW=false, SSH=false" "" "$(_lyns_query*)"
  SSH_CONNECTION='ssh'
  assertEquals "SHOW=false, SSH=true" "" "$(_lyns_query*)"

  LYNS_STATICUSER_SHOW=needed
  SSH_CONNECTION=''
  assertEquals "SHOW=needed, SSH=false" "" "$(_lyns_query*)"
  SSH_CONNECTION='ssh'
  assertEquals "SHOW=needed, SSH=true" "" "$(_lyns_query*)"

  unset SSH_CONNECTION
}

test_user_color() {
  LYNS_STATICUSER_SHOW=always 
  LYNS_STATICUSER_COLOR=green

  local expected="%{%B%}with %{%b%}%{%B%F{$LYNS_STATICUSER_COLOR}%}%n%{%b%f%}%{%B%} %{%b%}"
  local actual="$(_lyns_query*)"

  assertEquals "render user with custom color" "$expected" "$actual"
}

test_user_prefix() {
  LYNS_STATICUSER_SHOW=always 
  LYNS_STATICUSER_PREFIX='prefix'
  LYNS_STATICUSER_SUFFIX=''

  local expected="%{%B%}$LYNS_STATICUSER_PREFIX%{%b%}%{%B%F{yellow}%}%n%{%b%f%}%{%B%}$LYNS_STATICUSER_SUFFIX%{%b%}"
  local actual="$(_lyns_query*)"

  assertEquals "render user with prefix" "$expected" "$actual"
}

test_user_suffix() {
  LYNS_STATICUSER_SHOW=always 
  LYNS_STATICUSER_PREFIX=''
  LYNS_STATICUSER_SUFFIX='suffix'

  local expected="%{%B%}$LYNS_STATICUSER_PREFIX%{%b%}%{%B%F{yellow}%}%n%{%b%f%}%{%B%}$LYNS_STATICUSER_SUFFIX%{%b%}"
  local actual="$(_lyns_query*)"

  assertEquals "render user with suffix" "$expected" "$actual"
}

source tests/shunit2/shunit2
