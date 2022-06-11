
LYNS_AWS_SHOW="${LYNS_AWS_SHOW=true}"
LYNS_AWS_PREFIX="${LYNS_AWS_PREFIX="using "}"
LYNS_AWS_SUFFIX="${LYNS_AWS_SUFFIX="$LYNS_STATIC_DEFAULT_SUFFIX"}"
LYNS_AWS_SYMBOL="${LYNS_AWS_SYMBOL="☁️ "}"
LYNS_AWS_COLOR="${LYNS_AWS_COLOR="208"}"

_lyns_aws() {
  [[ $LYNS_QUERY_AWS_SHOW == false ]] && return
  
  asyncs::exists aws || return

  
  [[ -z $AWS_PROFILE ]] || [[ "$AWS_PROFILE" == "default" ]] && return
  
  asyncs::section \
    "$LYNS_AWS_COLOR" \
    "$LYNS_AWS_PREFIX" \
    "${LYNS_AWS_SYMBOL}$AWS_PROFILE" \
    "$LYNS_AWS_SUFFIX"
}
