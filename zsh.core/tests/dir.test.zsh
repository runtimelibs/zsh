
setopt shwordsplit
SHUNIT_PARENT=$0

oneTimeSetUp() {
  export TERM="xterm-256color"

  LYNS_QUERY_FIRST_PREFIX_SHOW=true
  LYNS_QUERY_ADD_NEWLINE=false
  LYNS_QUERY_ORDER=(dir)

  source asyncs.zsh
}

setUp() {
  LYNS_STATICDIR_SHOW=true
  LYNS_STATICDIR_PREFIX="in "
  LYNS_STATICDIR_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"
  LYNS_STATICDIR_TRUNC=3
  LYNS_STATICDIR_TRUNC_REPO=true
  LYNS_STATICDIR_COLOR="cyan"
}

oneTimeTearDown() {
  unset LYNS_QUERY_FIRST_PREFIX_SHOW
  unset LYNS_QUERY_ADD_NEWLINE
  unset LYNS_QUERY_ORDER
}

tearDown() {
  unset LYNS_STATICDIR_SHOW
  unset LYNS_STATICDIR_PREFIX
  unset LYNS_STATICDIR_SUFFIX
  unset LYNS_STATICDIR_TRUNC
  unset LYNS_STATICDIR_TRUNC_REPO
  unset LYNS_STATICDIR_COLOR
}

test_dir_home() {
  cd ~

  local expected="%{%B%}in %{%b%}%{%B%F{$LYNS_STATICDIR_COLOR}%}%(4~||)%3~%{%b%f%}%{%B%} %{%b%}"
  local actual="$(_lyns_query*)"

  assertEquals "render dir" "$expected" "$actual"
}

test_dir_color() {
  LYNS_STATICDIR_COLOR=blue

  local expected="%{%B%}in %{%b%}%{%B%F{$LYNS_STATICDIR_COLOR}%}%(4~||)%3~%{%b%f%}%{%B%} %{%b%}"
  local actual="$(_lyns_query*)"

  assertEquals "render dir with custom color" "$expected" "$actual"
}

test_dir_prefix() {
  LYNS_STATICDIR_PREFIX='prefix'
  LYNS_STATICDIR_SUFFIX=''

  local expected="%{%B%}$LYNS_STATICDIR_PREFIX%{%b%}%{%B%F{cyan}%}%(4~||)%3~%{%b%f%}%{%B%}$LYNS_STATICDIR_SUFFIX%{%b%}"
  local actual="$(_lyns_query*)"

  assertEquals "render dir with prefix" "$expected" "$actual"
}

test_dir_suffix() {
  LYNS_STATICDIR_PREFIX=''
  LYNS_STATICDIR_SUFFIX='suffix'

  local expected="%{%B%}$LYNS_STATICDIR_PREFIX%{%b%}%{%B%F{cyan}%}%(4~||)%3~%{%b%f%}%{%B%}$LYNS_STATICDIR_SUFFIX%{%b%}"
  local actual="$(_lyns_query*)"

  assertEquals "render dir with suffix" "$expected" "$actual"
}

test_dir_trunc() {
  LYNS_STATICDIR_TRUNC=2

  local expected="%{%B%}in %{%b%}%{%B%F{cyan}%}%($((LYNS_STATICDIR_TRUNC+1))~||)%$LYNS_STATICDIR_TRUNC~%{%b%f%}%{%B%} %{%b%}"
  local actual="$(_lyns_query*)"

  assertEquals "render truncated dir" "$expected" "$actual"
}

test_dir_trunc_git() {
  local REPO="$SHUNIT_TMPDIR/dir/trunc_git/dir1/dir2/dir3"
  mkdir -p $REPO/dir4/dir5

  cd $REPO
  command git init >/dev/null

  cd $REPO/dir4/dir5

  local expected="%{%B%}in %{%b%}%{%B%F{cyan}%}dir3/dir4/dir5%{%b%f%}%{%B%} %{%b%}"
  local actual="$(_lyns_query*)"

  assertEquals "render truncated dir in git repos" "$expected" "$actual"
}

test_dir_trunc_git_submodule() {
  local FOLDER="$SHUNIT_TMPDIR/dir/trunc_git_submodule"
  local REPO="$FOLDER/dir1/dir2/dir3"
  local SUBMODULE="$FOLDER/dir1/dir2/dir4"

  mkdir -p $REPO
  mkdir -p $SUBMODULE

  cd $SUBMODULE
  command git init >/dev/null
  command touch sample.txt
  command git add sample.txt >/dev/null
  command git commit -m  "Add sample file" >/dev/null

  cd $REPO
  command git init >/dev/null
  command touch sample.txt
  command git add sample.txt >/dev/null
  command git commit -m "Add sample file" >/dev/null
  command git submodule add $SUBMODULE 2&>/dev/null

  cd dir4

  local expected="%{%B%}in %{%b%}%{%B%F{cyan}%}dir4%{%b%f%}%{%B%} %{%b%}"
  local actual="$(_lyns_query*)"

  assertEquals "render submodule dir in the git repo" "$expected" "$actual"
}

source tests/shunit2/shunit2
