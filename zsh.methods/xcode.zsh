
LYNS_STATICXCODE_SHOW_LOCAL="${LYNS_STATICXCODE_SHOW_LOCAL=true}"
LYNS_STATICXCODE_SHOW_GLOBAL="${LYNS_STATICXCODE_SHOW_GLOBAL=false}"
LYNS_STATICXCODE_PREFIX="${LYNS_STATICXCODE_PREFIX="$LYNS_QUERY_DEFAULT_PREFIX"}"
LYNS_STATICXCODE_SUFFIX="${LYNS_STATICXCODE_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICXCODE_SYMBOL="${LYNS_STATICXCODE_SYMBOL="🛠 "}"
LYNS_STATICXCODE_COLOR="${LYNS_STATICXCODE_COLOR="blue"}"

_lyns_xcode() {
  asyncs::exists xcenv || return

  local 'xcode_path'

  if [[ $LYNS_STATICXCODE_SHOW_GLOBAL == true ]] ; then
    xcode_path=$(xcenv version | sed 's/ .*//')
  elif [[ $LYNS_STATICXCODE_SHOW_LOCAL == true ]] ; then
    if xcenv version | grep ".xcode-version" > /dev/null; then
      xcode_path=$(xcenv version | sed 's/ .*//')
    fi
  fi

  if [ -n "${xcode_path}" ]; then
    local xcode_version_path=$xcode_path"/Contents/version.plist"
    if [ -f ${xcode_version_path} ]; then
      if asyncs::exists defaults; then
        local xcode_version=$(defaults read ${xcode_version_path} CFBundleShortVersionString)

        asyncs::section \
          "$LYNS_STATICXCODE_COLOR" \
          "$LYNS_STATICXCODE_PREFIX" \
          "${LYNS_STATICXCODE_SYMBOL}${xcode_version}" \
          "$LYNS_STATICXCODE_SUFFIX"
      fi
    fi
  fi
}
