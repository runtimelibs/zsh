
LYNS_STATICCONDA_SHOW="${LYNS_STATICCONDA_SHOW=true}"
LYNS_STATICCONDA_PREFIX="${LYNS_STATICCONDA_PREFIX="$LYNS_QUERY_DEFAULT_PREFIX"}"
LYNS_STATICCONDA_SUFFIX="${LYNS_STATICCONDA_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICCONDA_SYMBOL="${LYNS_STATICCONDA_SYMBOL="🅒 "}"
LYNS_STATICCONDA_COLOR="${LYNS_STATICCONDA_COLOR="blue"}"
LYNS_STATICCONDA_VERBOSE="${LYNS_STATICCONDA_VERBOSE=true}"

_lyns_conda() {
  [[ $LYNS_STATICCONDA_SHOW == false ]] && return

  
  asyncs::exists conda && [ -n "$CONDA_DEFAULT_ENV" ] || return

  local conda_env=${CONDA_DEFAULT_ENV}

  if [[ $LYNS_STATICCONDA_VERBOSE == false ]]; then
    conda_env=${CONDA_DEFAULT_ENV:t}
  fi

  asyncs::section \
    "$LYNS_STATICCONDA_COLOR" \
    "$LYNS_STATICCONDA_PREFIX" \
    "${LYNS_STATICCONDA_SYMBOL}${conda_env}" \
    "$LYNS_STATICCONDA_SUFFIX"
}