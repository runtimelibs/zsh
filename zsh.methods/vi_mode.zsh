
LYNS_STATICVI_MODE_SHOW="${LYNS_STATICVI_MODE_SHOW=true}"
LYNS_STATICVI_MODE_PREFIX="${LYNS_STATICVI_MODE_PREFIX=""}"
LYNS_STATICVI_MODE_SUFFIX="${LYNS_STATICVI_MODE_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICVI_MODE_INSERT="${LYNS_STATICVI_MODE_INSERT="[I]"}"
LYNS_STATICVI_MODE_NORMAL="${LYNS_STATICVI_MODE_NORMAL="[N]"}"
LYNS_STATICVI_MODE_COLOR="${LYNS_STATICVI_MODE_COLOR="white"}"

_lyns_vi_mode() {
  [[ $LYNS_STATICVI_MODE_SHOW == true ]] || return

  if bindkey | grep "vi-quoted-insert" > /dev/null 2>&1; then 
    local mode_indicator="${LYNS_STATICVI_MODE_INSERT}"

    case "${KEYMAP}" in
      main|viins)
      mode_indicator="${LYNS_STATICVI_MODE_INSERT}"
      ;;
      vicmd)
      mode_indicator="${LYNS_STATICVI_MODE_NORMAL}"
      ;;
    esac

    asyncs::section \
      "$LYNS_STATICVI_MODE_COLOR" \
      "$LYNS_STATICVI_MODE_PREFIX" \
      "$mode_indicator" \
      "$LYNS_STATICVI_MODE_SUFFIX"
  fi
}

_lyns_vi_mode_enable() {
  function zle-keymap-select() { zle reset-prompt ; zle -R }
  zle -N zle-keymap-select
  bindkey -v
}

_lyns_vi_mode_disable() {
  bindkey -e
}
