
setopt shwordsplit
SHUNIT_PARENT=$0

oneTimeSetUp() {
  export TERM="xterm-256color"
  export PATH=$PWD/tests/stubs:$PATH

  LYNS_QUERY_FIRST_PREFIX_SHOW=true
  LYNS_QUERY_ADD_NEWLINE=false
  LYNS_QUERY_ORDER=(elm)

  source asyncs.zsh
}

setUp() {
  LYNS_STATICELM_SHOW=true
  LYNS_STATICELM_PREFIX="via "
  LYNS_STATICELM_SUFFIX=""
  LYNS_STATICELM_SYMBOL="🌳 "
  LYNS_STATICELM_COLOR="cyan"

  cd $SHUNIT_TMPDIR
  touch test.elm
}

oneTimeTearDown() {
  unset LYNS_QUERY_FIRST_PREFIX_SHOW
  unset LYNS_QUERY_ADD_NEWLINE
  unset LYNS_QUERY_ORDER
}

tearDown() {
  unset LYNS_STATICELM_SHOW
  unset LYNS_STATICELM_PREFIX
  unset LYNS_STATICELM_SUFFIX
  unset LYNS_STATICELM_SYMBOL
  unset LYNS_STATICELM_COLOR
}





test_elm() {
  local expected="%{%B%}via %{%b%}%{%B%F{cyan}%}🌳 v0.20.0%{%b%f%}%{%B%}%{%b%}"
  local actual="$(_lyns_query*)"

  assertEquals "render elm" "$expected" "$actual"
}

test_elm_show_false() {
  LYNS_STATICELM_SHOW=false

  local expected=""
  local actual="$(_lyns_query*)"

  assertEquals "don't render elm" "$expected" "$actual"
}

test_elm_files() {
  local expected="%{%B%}via %{%b%}%{%B%F{cyan}%}🌳 v0.20.0%{%b%f%}%{%B%}%{%b%}"
  local actual="$(_lyns_query*)"

  assertEquals "render elm when test.elm exists" "$expected" "$actual"

  rm test.elm
  touch elm.json

  local actual="$(_lyns_query*)"

  assertEquals "render elm when elm.json exists" "$expected" "$actual"

  rm elm.json
  touch elm-package.json

  local actual="$(_lyns_query*)"

  assertEquals "render elm when elm-package.json exists" "$expected" "$actual"

  rm elm-package.json
  mkdir elm-stuff

  local actual="$(_lyns_query*)"

  assertEquals "render elm when elm-stuff exists" "$expected" "$actual"

  rm -r elm-stuff

  local expected=""
  local actual="$(_lyns_query*)"

  assertEquals "don't render when no elm files are present" "$expected" "$actual"
}

test_elm_symbol() {
  LYNS_STATICELM_SYMBOL="🌵 "

  local expected="%{%B%}via %{%b%}%{%B%F{cyan}%}🌵 v0.20.0%{%b%f%}%{%B%}%{%b%}"
  local actual="$(_lyns_query*)"

  assertEquals "render elm with custom symbol" "$expected" "$actual"
}

test_elm_prefix() {
  LYNS_STATICELM_PREFIX='prefix'
  LYNS_STATICELM_SUFFIX=''

  local expected="%{%B%}prefix%{%b%}%{%B%F{cyan}%}🌳 v0.20.0%{%b%f%}%{%B%}%{%b%}"
  local actual="$(_lyns_query*)"

  assertEquals "render elm with prefix" "$expected" "$actual"
}

test_elm_suffix() {
  LYNS_STATICELM_PREFIX=''
  LYNS_STATICELM_SUFFIX='suffix'

  local expected="%{%B%}%{%b%}%{%B%F{cyan}%}🌳 v0.20.0%{%b%f%}%{%B%}suffix%{%b%}"
  local actual="$(_lyns_query*)"

  assertEquals "render elm with suffix" "$expected" "$actual"
}






source tests/shunit2/shunit2
