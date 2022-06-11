
LYNS_STATICHOST_SHOW="${LYNS_STATICHOST_SHOW=true}"
LYNS_STATICHOST_SHOW_FULL="${LYNS_STATICHOST_SHOW_FULL=false}"
LYNS_STATICHOST_PREFIX="${LYNS_STATICHOST_PREFIX="at "}"
LYNS_STATICHOST_SUFFIX="${LYNS_STATICHOST_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICHOST_COLOR="${LYNS_STATICHOST_COLOR="blue"}"
LYNS_STATICHOST_COLOR_SSH="${LYNS_STATICHOST_COLOR_SSH="green"}"

_lyns_host() {
  [[ $LYNS_STATICHOST_SHOW == false ]] && return

  if [[ $LYNS_STATICHOST_SHOW == 'always' ]] || [[ -n $SSH_CONNECTION ]]; then
    local host_color host

    
    if [[ -n $SSH_CONNECTION ]]; then
      host_color=$LYNS_STATICHOST_COLOR_SSH
    else
      host_color=$LYNS_STATICHOST_COLOR
    fi

    if [[ $LYNS_STATICHOST_SHOW_FULL == true ]]; then
      host="%M"
    else
      host="%m"
    fi

    asyncs::section \
      "$host_color" \
      "$LYNS_STATICHOST_PREFIX" \
      "$host" \
      "$LYNS_STATICHOST_SUFFIX"
  fi
}
