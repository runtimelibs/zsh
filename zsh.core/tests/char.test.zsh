
setopt shwordsplit
SHUNIT_PARENT=$0

oneTimeSetUp() {
  export TERM="xterm-256color"

  LYNS_QUERY_FIRST_PREFIX_SHOW=true
  LYNS_QUERY_ADD_NEWLINE=false
  LYNS_QUERY_ORDER=(char)

  source asyncs.zsh
}

setUp() {
  LYNS_STATICCHAR_PREFIX=""
  LYNS_STATICCHAR_SUFFIX=""
  LYNS_STATICCHAR_SYMBOL="➜ "
  LYNS_STATICCHAR_COLOR_SUCCESS="green"
  LYNS_STATICCHAR_COLOR_FAILURE="red"
  LYNS_STATICCHAR_COLOR_SECONDARY="yellow"
}

oneTimeTearDown() {
  unset LYNS_QUERY_FIRST_PREFIX_SHOW
  unset LYNS_QUERY_ADD_NEWLINE
  unset LYNS_QUERY_ORDER
}

tearDown() {
  unset LYNS_STATICCHAR_PREFIX
  unset LYNS_STATICCHAR_SUFFIX
  unset LYNS_STATICCHAR_SYMBOL
  unset LYNS_STATICCHAR_COLOR_SUCCESS
  unset LYNS_STATICCHAR_COLOR_FAILURE
  unset LYNS_STATICCHAR_COLOR_SECONDARY
}

test_char() {
  LYNS_STATICCHAR_COLOR_SUCCESS=blue
  local expected="%{%B%}%{%b%}%{%B%F{$LYNS_STATICCHAR_COLOR_SUCCESS}%}➜ %{%b%f%}%{%B%}%{%b%}"
  local actual="$(_lyns_query*)"

  assertEquals "render char" "$expected" "$actual"
}

test_char_failure() {
  LYNS_STATICCHAR_COLOR_FAILURE=yellow
  local expected="%{%B%}%{%b%}%{%B%F{$LYNS_STATICCHAR_COLOR_FAILURE}%}➜ %{%b%f%}%{%B%}%{%b%}"
  command false 
  local actual="$(_lyns_query*)"

  assertEquals "render char with failure" "$expected" "$actual"
}

test_char_symbol() {
  LYNS_STATICCHAR_SYMBOL='-> '

  local expected="%{%B%}%{%b%}%{%B%F{green}%}$LYNS_STATICCHAR_SYMBOL%{%b%f%}%{%B%}%{%b%}"
  local actual="$(_lyns_query*)"

  assertEquals "render char with custom symbol" "$expected" "$actual"
}

test_char_prefix() {
  LYNS_STATICCHAR_PREFIX='prefix'
  LYNS_STATICCHAR_SUFFIX=''

  local expected="%{%B%}$LYNS_STATICCHAR_PREFIX%{%b%}%{%B%F{green}%}➜ %{%b%f%}%{%B%}$LYNS_STATICCHAR_SUFFIX%{%b%}"
  local actual="$(_lyns_query*)"

  assertEquals "render char with prefix" "$expected" "$actual"
}

test_char_suffix() {
  LYNS_STATICCHAR_PREFIX=''
  LYNS_STATICCHAR_SUFFIX='suffix'

  local expected="%{%B%}$LYNS_STATICCHAR_PREFIX%{%b%}%{%B%F{green}%}➜ %{%b%f%}%{%B%}$LYNS_STATICCHAR_SUFFIX%{%b%}"
  local actual="$(_lyns_query*)"

  assertEquals "render char with suffix" "$expected" "$actual"
}

source tests/shunit2/shunit2
