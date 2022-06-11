#!/usr/bin/env zsh

_lyns_query*_opened="$LYNS_QUERY_FIRST_PREFIX_SHOW"

asyncs::section() {
  local color prefix content suffix
  [[ -n $1 ]] && color="%F{$1}"  || color="%f"
  [[ -n $2 ]] && prefix="$2"     || prefix=""
  [[ -n $3 ]] && content="$3"    || content=""
  [[ -n $4 ]] && suffix="$4"     || suffix=""

  [[ -z $3 && -z $4 ]] && content=$2 prefix=''

  echo -n "%{%B%}" 
  if [[ $_lyns_query*_opened == true ]] && [[ $LYNS_QUERY_PREFIXES_SHOW == true ]]; then
    echo -n "$prefix"
  fi
  _lyns_query*_opened=true
  echo -n "%{%b%}" 

  echo -n "%{%B$color%}" 
  echo -n "$content"     
  echo -n "%{%b%f%}"     

  echo -n "%{%B%}" 
  if [[ $LYNS_QUERY_SUFFIXES_SHOW == true ]]; then
    echo -n "$suffix"
  fi
  echo -n "%{%b%}" 
}

asyncs::compose_prompt() {
  
  setopt EXTENDED_GLOB LOCAL_OPTIONS

  for section in $@; do
    if asyncs::defined "_lyns_$section"; then
      _lyns_$section
    else
      asyncs::section 'red' "'$section' not found"
    fi
  done
}
