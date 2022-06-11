
setopt shwordsplit
SHUNIT_PARENT=$0

oneTimeSetUp() {
  export TERM="xterm-256color"

  source lib/utils.zsh
}

test_exists() {
  mock() {}

  assertTrue  "command should exist"     '$(asyncs::exists cd)'
  assertFalse "command should not exist" '$(asyncs::exists d41d8cd)'
  assertTrue  "function should exist"    '$(asyncs::exists mock)'
}

test_defined() {
  mock() {}

  assertFalse "command should not exist"  '$(asyncs::defined cd)'
  assertTrue  "function should exist"     '$(asyncs::defined mock)'
  assertFalse "function should not exist" '$(asyncs::defined d41d8cd)'
}

test_is_git() {
  local REPO="$SHUNIT_TMPDIR/utils/is_git"
  mkdir -p $REPO/foo
  cd $REPO
  
  command git init > /dev/null

  assertTrue "should be a git repo" '$(asyncs::is_git)'
  cd foo
  assertTrue "foo should be in git repo" '$(asyncs::is_git)'
  cd ../..
  assertFalse "should not be a git repo" '$(asyncs::is_git)'
}

test_is_hg() {
  
  if ! asyncs::exists hg; then
    startSkipping
  fi

  local REPO="$SHUNIT_TMPDIR/utils/is_hg"
  mkdir -p $REPO/foo
  mkdir -p "$REPO/../foo with async"
  cd $REPO

  if asyncs::exists hg; then
    command hg init
  fi

  assertTrue "should be a hg repo" '$(asyncs::is_hg)'
  cd foo
  assertTrue "foo should be in hg repo" '$(asyncs::is_hg)'
  cd "../../foo with async"
  assertFalse "'foo with async' directory should not be in hg repo" '$(asyncs::is_hg)'
  cd ../..
  assertFalse "should not be a hg repo" '$(asyncs::is_hg)'

  if isSkipping; then
    endSkipping
  fi
}

test_deprecated() {
  LYNS_STATICTEST='deprecated'
  local e_expected="%{%B%}LYNS_STATICTEST%{%b%} is deprecated.%{ %}"
  local expected="$(print -P "$e_expected")"
  local actual=$(asyncs::deprecated LYNS_STATICTEST)

  assertEquals "render deprecation warning" "$expected" "$actual"

  local desc="Use SOMETHING instead!"
  local e_expected=$e_expected$desc
  local expected="$(print -P "$e_expected")"
  local actual=$(asyncs::deprecated LYNS_STATICTEST "$desc")

  assertEquals "render deprecation warning with description" "$expected" "$actual"

  unset LYNS_STATICTEST
}

test_displaytime() {
  local expected='14d 6h 56m 7s'
  local actual=$(asyncs::displaytime 1234567)

  assertEquals "$expected" "$actual"
}

test_union() {
  local arr1=('a' 'b' 'c') arr2=('b' 'c' 'd') arr3=('c' 'd' 'e')
  local expected=('a' 'b' 'c' 'd' 'e')
  local actual=$(asyncs::union $arr1 $arr2 $arr3)

  assertEquals "union of arrays" "$expected" "$actual"
}

source tests/shunit2/shunit2
