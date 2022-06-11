
setopt shwordsplit
SHUNIT_PARENT=$0

oneTimeSetUp() {
  export TERM="xterm-256color"

  LYNS_QUERY_FIRST_PREFIX_SHOW=true
  LYNS_QUERY_ADD_NEWLINE=false
}

setUp() {
  echo "" > "${ZDOTDIR:-$HOME}/.zshrc"
  ./scripts/install.sh >/dev/null
}

test_uninstall_preserve_zshrc_content() {
  local zshrc_content_to_preserve="TEST=TEST"
  echo $zshrc_content_to_preserve >> "${ZDOTDIR:-$HOME}/.zshrc"

  ./scripts/uninstall.sh -y >/dev/null

  zshrc_content=$(<"${ZDOTDIR:-$HOME}/.zshrc")

  assertContains "preserve non asyncs related install config" "$zshrc_content" "$zshrc_content_to_preserve"
}

test_uninstall_remove__lyns_content_from_zshrc() {
  local _lyns_promt_order_env="LYNS_QUERY_ORDER=(
    time          
  )"
  echo $_lyns_promt_order_env >> "${ZDOTDIR:-$HOME}/.zshrc"

  ./scripts/uninstall.sh -y >/dev/null

  zshrc_content=$(<"${ZDOTDIR:-$HOME}/.zshrc")

  assertNotContains "remove asyncs load comment" "$zshrc_content" "
  assertNotContains "remove auto load prompt init" "$zshrc_content" "autoload -U promptinit; promptinit"
  assertNotContains "remove LYNS_QUERY_ORDER env" "$zshrc_content" "$_lyns_promt_order_env"
}

source tests/shunit2/shunit2
