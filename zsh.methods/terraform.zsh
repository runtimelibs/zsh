
LYNS_STATICTERRAFORM_SHOW="${LYNS_STATICTERRAFORM_SHOW=true}"
LYNS_STATICTERRAFORM_PREFIX="${LYNS_STATICTERRAFORM_PREFIX="$LYNS_QUERY_DEFAULT_PREFIX"}"
LYNS_STATICTERRAFORM_SUFFIX="${LYNS_STATICTERRAFORM_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICTERRAFORM_SYMBOL="${LYNS_STATICTERRAFORM_SYMBOL="🛠 "}"
LYNS_STATICTERRAFORM_COLOR="${LYNS_STATICTERRAFORM_COLOR="105"}"

_lyns_terraform() {
  [[ $LYNS_STATICTERRAFORM_SHOW == false ]] && return

  asyncs::exists terraform || return
  
  [[ -f .terraform/environment ]] || return

  local terraform_workspace=$(<.terraform/environment)
  [[ -z $terraform_workspace ]] && return

  asyncs::section \
    "$LYNS_STATICTERRAFORM_COLOR" \
    "$LYNS_STATICTERRAFORM_PREFIX" \
    "$LYNS_STATICTERRAFORM_SYMBOL$terraform_workspace" \
    "$LYNS_STATICTERRAFORM_SUFFIX"
}
