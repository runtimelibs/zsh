
setopt shwordsplit
SHUNIT_PARENT=$0

oneTimeSetUp() {
  export TERM="xterm-256color"

  source lib/utils.zsh
  source lib/section.zsh
}

setUp() {
  LYNS_QUERY_PREFIXES_SHOW=true
  LYNS_QUERY_SUFFIXES_SHOW=true
}

tearDown() {
  unset LYNS_QUERY_PREFIXES_SHOW
  unset LYNS_QUERY_SUFFIXES_SHOW
}

test_section() {
  local color="cyan" content="content" prefix="prefix" suffix="suffix"

  local expected_none="%{%B%}%{%b%}%{%B%f%}%{%b%f%}%{%B%}%{%b%}"
  local actual_none="$(asyncs::section)"

  assertEquals "render section without arguments" "$expected_none" "$actual_none"

  local expected_short="%{%B%}%{%b%}%{%B%F{$color}%}$content%{%b%f%}%{%B%}%{%b%}"
  local actual_short="$(asyncs::section $color $content)"

  assertEquals "render short section" "$expected_short" "$actual_short"

  local expected_suffix="%{%B%}%{%b%}%{%B%F{$color}%}$content%{%b%f%}%{%B%}$suffix%{%b%}"
  local actual_suffix="$(asyncs::section $color $prefix $content $suffix)"

  assertEquals "render full section with suffix" "$expected_suffix" "$actual_suffix"

  _lyns_query*_opened=true
  local expected="%{%B%}$prefix%{%b%}%{%B%F{$color}%}$content%{%b%f%}%{%B%}$suffix%{%b%}"
  local actual="$(asyncs::section $color $prefix $content $suffix)"

  assertEquals "render full section with prefix and suffix" "$expected" "$actual"
}

test_compose_prompt() {
  _lyns_foo() { echo -n 'foo' }
  _lyns_bar() { echo -n 'bar' }

  local TEST_SPACESHIP_ORDER=(foo bar)

  local expected="foobar"
  local actual="$(asyncs::compose_prompt $TEST_SPACESHIP_ORDER)"

  assertEquals "render asyncs sections" "$expected" "$actual"

  local TEST_SPACESHIP_ORDER_NOT_FOUND=(foo bar baz)

  local expected_not_found="foobar%{%B%}%{%b%}%{%B%F{red}%}'baz' not found%{%b%f%}%{%B%}%{%b%}"
  local actual_not_found="$(asyncs::compose_prompt $TEST_SPACESHIP_ORDER_NOT_FOUND)"

  assertEquals "render missing sections" "$expected_not_found" "$actual_not_found"
}

source tests/shunit2/shunit2
