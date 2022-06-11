
LYNS_STATICRUBY_SHOW="${LYNS_STATICRUBY_SHOW=true}"
LYNS_STATICRUBY_PREFIX="${LYNS_STATICRUBY_PREFIX="$LYNS_QUERY_DEFAULT_PREFIX"}"
LYNS_STATICRUBY_SUFFIX="${LYNS_STATICRUBY_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICRUBY_SYMBOL="${LYNS_STATICRUBY_SYMBOL="💎 "}"
LYNS_STATICRUBY_COLOR="${LYNS_STATICRUBY_COLOR="red"}"

_lyns_ruby() {
  [[ $LYNS_STATICRUBY_SHOW == false ]] && return
  
  [[ -f Gemfile || -f Rakefile || -n *.rb(

  local 'ruby_version'

  if asyncs::exists rvm-prompt; then
    ruby_version=$(rvm-prompt i v g)
  elif asyncs::exists chruby; then
    ruby_version=$(chruby | sed -n -e 's/ \* //p')
  elif asyncs::exists rbenv; then
    ruby_version=$(rbenv version-name)
  elif asyncs::exists asdf; then
    
    ruby_version=${$(asdf current ruby)[2]}
  else
    return
  fi

  [[ -z $ruby_version || "${ruby_version}" == "system" ]] && return

  
  [[ "${ruby_version}" =~ ^[0-9].+$ ]] && ruby_version="v${ruby_version}"

  asyncs::section \
    "$LYNS_STATICRUBY_COLOR" \
    "$LYNS_STATICRUBY_PREFIX" \
    "${LYNS_STATICRUBY_SYMBOL}${ruby_version}" \
    "$LYNS_STATICRUBY_SUFFIX"
}
