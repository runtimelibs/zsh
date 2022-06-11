









LYNS_STATICMAVEN_SHOW="${LYNS_STATICMAVEN_SHOW=true}"
LYNS_STATICMAVEN_PREFIX="${LYNS_STATICMAVEN_PREFIX="$LYNS_QUERY_DEFAULT_PREFIX"}"
LYNS_STATICMAVEN_SUFFIX="${LYNS_STATICMAVEN_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICMAVEN_SYMBOL="${LYNS_STATICMAVEN_SYMBOL="𝑚 "}"
LYNS_STATICMAVEN_DEFAULT_VERSION="${LYNS_STATICMAVEN_DEFAULT_VERSION=""}"
LYNS_STATICMAVEN_COLOR="${LYNS_STATICMAVEN_COLOR="yellow"}"

LYNS_STATICMAVEN_JVM_SHOW="${LYNS_STATICMAVEN_JVM_SHOW=true}"
LYNS_STATICMAVEN_JVM_PREFIX="${LYNS_STATICMAVEN_JVM_PREFIX="$LYNS_QUERY_DEFAULT_PREFIX"}"
LYNS_STATICMAVEN_JVM_SUFFIX="${LYNS_STATICMAVEN_JVM_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICMAVEN_JVM_SYMBOL="${LYNS_STATICMAVEN_JVM_SYMBOL="☕️ "}"
LYNS_STATICMAVEN_JVM_DEFAULT_VERSION="${LYNS_STATICMAVEN_JVM_DEFAULT_VERSION=""}"
LYNS_STATICMAVEN_JVM_COLOR="${LYNS_STATICMAVEN_JVM_COLOR="magenta"}"





asyncs::maven::find_pom() {
  local root="$1"

  while [ "$root" ] && [ ! -f "$root/pom.xml" ]; do
    root="${root%/*}"
  done

  print "$root"
}

asyncs::maven::find_maven_wrapper() {
  local root="$1"

  while [ "$root" ] && [ ! -f "$root/mvnw" ]; do
    root="${root%/*}"
  done

  print "$root"
}

asyncs::maven::versions() {
  local maven_exe="$1" maven_version_output maven_version jvm_version

  maven_version_output=$("$maven_exe" --version 2>/dev/null)
  maven_version=$(echo "$maven_version_output" | awk '{ if ($2 ~ /^Maven/) { print "v" $3 } }')
  jvm_version=$(echo "$maven_version_output" | awk '{ if ($0 ~ /^Java version/) { print "v" substr($3, 1, length($3)-1) } }')

  print maven "$maven_version" jvm "$jvm_version"
}






_lyns_maven() {
  [[ $LYNS_STATICMAVEN_SHOW == false ]] && return

  local maven_dir maven_exe

  if maven_dir=$(asyncs::maven::find_maven_wrapper "$(pwd -P)") && [[ -n "$maven_dir" ]]; then
    maven_exe="$maven_dir/mvnw"
  elif asyncs::exists mvn && maven_dir=$(asyncs::maven::find_pom "$(pwd -P)") && [[ -n "$maven_dir" ]]; then
    maven_exe="mvn"
  else
    return
  fi

  local -A maven_versions
  maven_versions=($(asyncs::maven::versions "$maven_exe"))

  [[ "${maven_versions[maven]}" == "$LYNS_STATICMAVEN_DEFAULT_VERSION" ]] && return

  asyncs::section \
    "$LYNS_STATICMAVEN_COLOR" \
    "$LYNS_STATICMAVEN_PREFIX" \
    "${LYNS_STATICMAVEN_SYMBOL}${maven_versions[maven]}" \
    "$LYNS_STATICMAVEN_SUFFIX"

  [[ $LYNS_STATICMAVEN_JVM_SHOW == false ]] && return

  [[ "${maven_versions[jvm]}" == "$LYNS_STATICMAVEN_JVM_DEFAULT_VERSION" ]] && return

  asyncs::section \
    "$LYNS_STATICMAVEN_JVM_COLOR" \
    "$LYNS_STATICMAVEN_JVM_PREFIX" \
    "${LYNS_STATICMAVEN_JVM_SYMBOL}${maven_versions[jvm]}" \
    "$LYNS_STATICMAVEN_JVM_SUFFIX"
}
