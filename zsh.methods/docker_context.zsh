
LYNS_STATICDOCKER_CONTEXT_SHOW="${LYNS_STATICDOCKER_CONTEXT_SHOW=true}"
LYNS_STATICDOCKER_CONTEXT_PREFIX="${LYNS_STATICDOCKER_CONTEXT_PREFIX=" ("}"
LYNS_STATICDOCKER_CONTEXT_SUFFIX="${LYNS_STATICDOCKER_CONTEXT_SUFFIX=")"}"

_lyns_docker_context() {
  [[ $LYNS_STATICDOCKER_CONTEXT_SHOW == false ]] && return

  local docker_remote_context

  if [[ -n $DOCKER_MACHINE_NAME ]]; then
    docker_remote_context="$DOCKER_MACHINE_NAME"
  elif [[ -n $DOCKER_HOST ]]; then
    
    docker_remote_context="$(basename $DOCKER_HOST | cut -d':' -f1)"
  else
    docker_remote_context=$(docker context ls --format '{{if .Current}}{{if and (ne .Name "default") (ne .Name "desktop-linux")}}{{.Name}}{{end}}{{end}}' 2>/dev/null)
    [[ $? -ne 0 ]] && return

    docker_remote_context=$(echo $docker_remote_context | tr -d '\n')
  fi

  [[ -z $docker_remote_context ]] && return

  asyncs::section \
    "$LYNS_STATICDOCKER_COLOR" \
    "$LYNS_STATICDOCKER_CONTEXT_PREFIX${docker_remote_context}$LYNS_STATICDOCKER_CONTEXT_SUFFIX"
}
