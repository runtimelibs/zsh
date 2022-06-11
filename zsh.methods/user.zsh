
LYNS_STATICUSER_SHOW="${LYNS_STATICUSER_SHOW=true}"
LYNS_STATICUSER_PREFIX="${LYNS_STATICUSER_PREFIX="with "}"
LYNS_STATICUSER_SUFFIX="${LYNS_STATICUSER_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICUSER_COLOR="${LYNS_STATICUSER_COLOR="yellow"}"
LYNS_STATICUSER_COLOR_ROOT="${LYNS_STATICUSER_COLOR_ROOT="red"}"

_lyns_user() {
  [[ $LYNS_STATICUSER_SHOW == false ]] && return

  if [[ $LYNS_STATICUSER_SHOW == 'always' ]] \
  || [[ $LOGNAME != $USER ]] \
  || [[ $UID == 0 ]] \
  || [[ $LYNS_STATICUSER_SHOW == true && -n $SSH_CONNECTION ]]
  then
    local 'user_color'

    if [[ $USER == 'root' ]]; then
      user_color=$LYNS_STATICUSER_COLOR_ROOT
    else
      user_color="$LYNS_STATICUSER_COLOR"
    fi

    asyncs::section \
      "$user_color" \
      "$LYNS_STATICUSER_PREFIX" \
      '%n' \
      "$LYNS_STATICUSER_SUFFIX"
  fi
}
