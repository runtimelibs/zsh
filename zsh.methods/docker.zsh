
LYNS_STATICDOCKER_SHOW="${LYNS_STATICDOCKER_SHOW=true}"
LYNS_STATICDOCKER_PREFIX="${LYNS_STATICDOCKER_PREFIX="on "}"
LYNS_STATICDOCKER_SUFFIX="${LYNS_STATICDOCKER_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICDOCKER_SYMBOL="${LYNS_STATICDOCKER_SYMBOL="🐳 "}"
LYNS_STATICDOCKER_COLOR="${LYNS_STATICDOCKER_COLOR="cyan"}"
LYNS_STATICDOCKER_VERBOSE="${LYNS_STATICDOCKER_VERBOSE=false}"

source "$LYNS_STATICROOT/sections/docker_context.zsh"

_lyns_docker() {
  [[ $LYNS_STATICDOCKER_SHOW == false ]] && return

  asyncs::exists docker || return

  
  local compose_exists=false
  if [[ -n "$COMPOSE_FILE" ]]; then
    
    local separator=${COMPOSE_PATH_SEPARATOR:-":"}

    
    local filenames=("${(@ps/$separator/)COMPOSE_FILE}")

    for filename in $filenames; do
      if [[ ! -f $filename ]]; then
        compose_exists=false
        break
      fi
      compose_exists=true
    done

    
    [[ "$compose_exists" == false ]] && return
  fi

  local docker_context="$(_lyns_docker_context)"

  
  [[ "$compose_exists" == true || -f Dockerfile || -f docker-compose.yml || -f /.dockerenv || -n $docker_context ]] || return

  
  
  local 'docker_version'
  docker_version=$(docker version -f "{{.Server.Version}}" 2>/dev/null)
  [[ $? -ne 0 || -z $docker_version ]] && return

  [[ $LYNS_STATICDOCKER_VERBOSE == false ]] && docker_version=${docker_version%-*}

  asyncs::section \
    "$LYNS_STATICDOCKER_COLOR" \
    "$LYNS_STATICDOCKER_PREFIX" \
    "${LYNS_STATICDOCKER_SYMBOL}v${docker_version}${docker_context}" \
    "$LYNS_STATICDOCKER_SUFFIX"
}
