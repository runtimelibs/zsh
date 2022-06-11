
LYNS_STATICSWIFT_SHOW_LOCAL="${LYNS_STATICSWIFT_SHOW_LOCAL=true}"
LYNS_STATICSWIFT_SHOW_GLOBAL="${LYNS_STATICSWIFT_SHOW_GLOBAL=false}"
LYNS_STATICSWIFT_PREFIX="${LYNS_STATICSWIFT_PREFIX="$LYNS_QUERY_DEFAULT_PREFIX"}"
LYNS_STATICSWIFT_SUFFIX="${LYNS_STATICSWIFT_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICSWIFT_SYMBOL="${LYNS_STATICSWIFT_SYMBOL="🐦 "}"
LYNS_STATICSWIFT_COLOR="${LYNS_STATICSWIFT_COLOR="yellow"}"

_lyns_swift() {
  asyncs::exists swiftenv || return

  local 'swift_version'

  if [[ $LYNS_STATICSWIFT_SHOW_GLOBAL == true ]] ; then
    swift_version=$(swiftenv version | sed 's/ .*//')
  elif [[ $LYNS_STATICSWIFT_SHOW_LOCAL == true ]] ; then
    if swiftenv version | grep ".swift-version" > /dev/null; then
      swift_version=$(swiftenv version | sed 's/ .*//')
    fi
  fi

  [ -n "${swift_version}" ] || return

  asyncs::section \
    "$LYNS_STATICSWIFT_COLOR" \
    "$LYNS_STATICSWIFT_PREFIX" \
    "${LYNS_STATICSWIFT_SYMBOL}${swift_version}" \
    "$LYNS_STATICSWIFT_SUFFIX"
}
