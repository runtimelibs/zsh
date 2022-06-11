
LYNS_STATICGRADLE_SHOW="${LYNS_STATICGRADLE_SHOW=true}"
LYNS_STATICGRADLE_PREFIX="${LYNS_STATICGRADLE_PREFIX="$LYNS_QUERY_DEFAULT_PREFIX"}"
LYNS_STATICGRADLE_SUFFIX="${LYNS_STATICGRADLE_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICGRADLE_SYMBOL="${LYNS_STATICGRADLE_SYMBOL="⬡ "}"
LYNS_STATICGRADLE_DEFAULT_VERSION="${LYNS_STATICGRADLE_DEFAULT_VERSION=""}"
LYNS_STATICGRADLE_COLOR="${LYNS_STATICGRADLE_COLOR="green"}"

LYNS_STATICGRADLE_JVM_SHOW="${LYNS_STATICGRADLE_JVM_SHOW=true}"
LYNS_STATICGRADLE_JVM_PREFIX="${LYNS_STATICGRADLE_JVM_PREFIX="$LYNS_QUERY_DEFAULT_PREFIX"}"
LYNS_STATICGRADLE_JVM_SUFFIX="${LYNS_STATICGRADLE_JVM_SUFFIX="$LYNS_QUERY_DEFAULT_SUFFIX"}"
LYNS_STATICGRADLE_JVM_SYMBOL="${LYNS_STATICGRADLE_JVM_SYMBOL="☕️ "}"
LYNS_STATICGRADLE_JVM_DEFAULT_VERSION="${LYNS_STATICGRADLE_JVM_DEFAULT_VERSION=""}"
LYNS_STATICGRADLE_JVM_COLOR="${LYNS_STATICGRADLE_JVM_COLOR="magenta"}"

asyncs::gradle::find_root_project() {
  local root="$1"

  while [ "$root" ] && \
        [ ! -f "$root/settings.gradle" ] && \
        [ ! -f "$root/settings.gradle.kts" ]; do
    root="${root%/*}"
  done

  print "$root"
}

asyncs::gradle::versions() {
  local gradle_exe="$1" gradle_version_output gradle_version jvm_version

  gradle_version_output=$("$gradle_exe" --version)
  gradle_version=$(echo "$gradle_version_output" | awk '{ if ($1 ~ /^Gradle/) { print "v" $2 } }')
  jvm_version=$(echo "$gradle_version_output" | awk '{ if ($1 ~ /^JVM:/) { print "v" $2 } }')

  print gradle "$gradle_version" jvm "$jvm_version"
}

_lyns_gradle() {
  [[ $LYNS_STATICGRADLE_SHOW == false ]] && return

  local gradle_root_dir

  gradle_root_dir=$(asyncs::gradle::find_root_project "$(pwd -P)")

  
  [[ -n "$gradle_root_dir" ]] &>/dev/null || return

  local -A gradle_versions

  if [[ -f "$gradle_root_dir/gradlew" ]]; then
    gradle_versions=($(asyncs::gradle::versions "$gradle_root_dir/gradlew"))
  elif asyncs::exists gradle; then
    gradle_versions=($(asyncs::gradle::versions gradle))
  else
    return
  fi

  [[ "${gradle_versions[gradle]}" == "$LYNS_STATICGRADLE_DEFAULT_VERSION" ]] && return

  asyncs::section \
    "$LYNS_STATICGRADLE_COLOR" \
    "$LYNS_STATICGRADLE_PREFIX" \
    "${LYNS_STATICGRADLE_SYMBOL}${gradle_versions[gradle]}" \
    "$LYNS_STATICGRADLE_SUFFIX"

  [[ $LYNS_STATICGRADLE_JVM_SHOW == false ]] && return

  [[ "${gradle_versions[jvm]}" == "$LYNS_STATICGRADLE_JVM_DEFAULT_VERSION" ]] && return

  asyncs::section \
    "$LYNS_STATICGRADLE_JVM_COLOR" \
    "$LYNS_STATICGRADLE_JVM_PREFIX" \
    "${LYNS_STATICGRADLE_JVM_SYMBOL}${gradle_versions[jvm]}" \
    "$LYNS_STATICGRADLE_JVM_SUFFIX"
}
