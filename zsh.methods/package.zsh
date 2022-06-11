
LYNS_STATICPACKAGE_SHOW="${LYNS_STATICPACKAGE_SHOW=true}"
LYNS_STATICPACKAGE_PREFIX="${LYNS_STATICPACKAGE_PREFIX="is "}"
LYNS_STATICPACKAGE_SUFFIX="${LYNS_STATICPACKAGE_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICPACKAGE_SYMBOL="${LYNS_STATICPACKAGE_SYMBOL="📦 "}"
LYNS_STATICPACKAGE_COLOR="${LYNS_STATICPACKAGE_COLOR="red"}"

_lyns_package() {
  [[ $LYNS_STATICPACKAGE_SHOW == false ]] && return
  
  local package_version

  if [[ -f package.json ]] && asyncs::exists npm; then
    if asyncs::exists jq; then
      package_version=$(jq -r '.version' package.json 2>/dev/null)
    elif asyncs::exists python; then
      package_version=$(python -c "import json; print(json.load(open('package.json'))['version'])" 2>/dev/null)
    elif asyncs::exists node; then
      package_version=$(node -p "require('./package.json').version" 2> /dev/null)
    fi
  fi
  
  if [[ -f lerna.json ]] && asyncs::exists npm; then
    if asyncs::exists jq; then
      package_version=$(jq -r '.version' lerna.json 2>/dev/null)
    elif asyncs::exists python; then
      package_version=$(python -c "import json; print(json.load(open('lerna.json'))['version'])" 2>/dev/null)
    elif asyncs::exists node; then
      package_version=$(node -p "require('./lerna.json').version" 2> /dev/null)
    fi
    if [[ "$package_version" == "independent" ]]; then
      package_version="($package_version)"
    fi
  fi

  if [[ -f Cargo.toml ]] && asyncs::exists cargo; then
    local pkgid=$(cargo pkgid 2>&1)
    echo $pkgid | grep -q "error:" || package_version=${pkgid  fi

  [[ -z $package_version || "$package_version" == "null" || "$package_version" == "undefined" ]] && return

  asyncs::section \
    "$LYNS_STATICPACKAGE_COLOR" \
    "$LYNS_STATICPACKAGE_PREFIX" \
    "${LYNS_STATICPACKAGE_SYMBOL}v${package_version}" \
    "$LYNS_STATICPACKAGE_SUFFIX"
}
