#!/usr/bin/env bash
#
# Author: Hsieh Chin Fan (typebrook) <typebrook@gmail.com>
# License: MIT
# https://gist.github.com/typebrook/b0d2e7e67aa50298fdf8111ae7466b56
#
# --
# gist
# Description: Manage your gists with git and Github API v3
# Usage: gist [command] [<args>]
#
#   [star|s|all|a]                List your gists, use 'star' or 's' for your starred gists,
#                                 'all' or 'a' for both your and starred gists. Format for each line is:
#                                 <INDEX> <URL> <FILE_NUM> <COMMENT_NUM> <DESCRIPTION>
#   fetch,  f [star|s]            Update the local list of your gists, 'star' for your starred gists
#   <INDEX> [-n|--no-action]      Show the path of local gist repo and do custom actions(enter sub-shell by default)
#   new,    n [-d |--desc <description>] [-p] <FILE>...      create a new gist with files
#   new,    n [-d |--desc <description>] [-p] [-f|--file <FILE_NAME>] create a new gist from STDIN
#   grep,   g <PATTERN>           Grep gists by description, filename and content with a given pattern
#   tag,    t <INDEX>             Modify tags for a gist
#   tag,    t <TAG>...            Grep gists with tags
#   tag,    t                     List gist with tags and pinned tags
#   tags,   tt                    List all tags and pinned tags
#   pin,    p <TAG>...            Pin/Unpin tags
#   pin,    p                     Grep gists with pinned tags
#   lan,    l <PATTERN>...        Grep gists with languages
#   lan,    l                     List gist with languages of files
#   detail, d <INDEX>             Show the detail of a gist
#   edit,   e <INDEX> ["NEW_DESCRIPTRION"]  Edit description of the given gist
#   delete, D <INDEX>... [--force]          Delete gists by given indices
#   push,   P <INDEX>             Push changes by git (Well... better to make commit by youself)
#   clean,  C                     Clean local repos of removed gists
#   config, c                     Configure with editor, will show all valid keys
#   config, c <VALID_KEY> [value] Configure a single option. If no value is specified, apply default setting
#   user,   u <USER>              Get list of gists with a given Github user
#   github, G <INDEX>             Export selected gist as a new Github repo
#   id        <INDEX>             Print the gist ID
#   url       <INDEX>             Print the gist URL
#   help,   h                     Show this help message
# 
# Example:
#   gist fetch              (update the list of gists from github.com)
#   gist                    (Show your gists)
#   gist 3                  (show the repo path of your 3rd gist, and do custom actions)
#   gist 3 --no-action      (show the repo path of your 3rd gist, and do not perform actions)
#   gist new foo bar        (create a new gist with files foo and bar)
#   gist tag                (Show your gists with tags)
#   gist tag 3              (Add tags to your 3rd gist)
#   gist tag .+             (show tagged gists)
# 
# Since now a gist is a local cloned repo
# It is your business to do git commit and git push

configuredClient=""

declare -r NAME=${GISTSCRIPT:-$(basename $0)} #show hint and helper message with current script name
declare -r GITHUB_API=https://api.github.com
declare -r GIST_DOMAIN=https://gist.github.com
declare -r CONFIG=~/.config/gist.conf; mkdir -p ~/.config
declare -r per_page=100

declare -ar INDEX_FORMAT=('index' 'public' 'gist_id' 'tags_string' 'blob_code' 'file_array' 'file_num' 'comment_num' 'author' 'created_at' 'updated_at' 'description')
declare -ar VALID_CONFIGS=('user' 'token' 'folder' 'auto_sync' 'action' 'EDITOR' 'protocol' 'show_untagged' 'pin')
declare -A  CONFIG_VALUES=([auto_sync]='true|false' [protocol]='https|ssh' [show_untagged]='true|false')

TAG_CHAR='-_[:alnum:]'
if [[ ! -t 0 ]]; then
  INPUT=$(cat)
  export mark=.
else
  export mark=[^s] # By defaut, only process user's gists, not starred gist
fi

# Default configuration
python() { type python3 >&/dev/null && python3 "$@" || python "$@"; }
if [[ ! -t 1 && -z $hint ]]; then
  hint=false
  PIPE_TO_SOMEWHERE=true
fi
init=

# Shell configuration
set -o pipefail
[[ $TRACE == 'true' ]] && set -x

# clean temporary files
tmp_dir=$(mktemp -d)
trap "[[ '$DEBUG' == 'true' ]] && tail -n +1 $tmp_dir/* >log 2>/dev/null; rm -r $tmp_dir" EXIT

# Mac compatibility
tmp_file() {
  if [[ $(uname) == Darwin ]]; then 
    TMPDIR=$tmp_dir mktemp -t $1
  else
    mktemp -p $tmp_dir -t $1.XXXXXX
  fi
}
tac() { sed -e '1! G; h; $!d'; } # An easy way to reverse file content both on Linux and Darwin
mtime() {
  if [[ $(uname) == Darwin ]]; then 
    stat -x $1 | grep Modify | cut -d' ' -f2- 
  else
    stat -c %y $1
  fi
}

# This function determines which http get tool the system has installed and returns an error if there isnt one
getConfiguredClient() {
  if  command -v curl &>/dev/null; then
    configuredClient="curl"
  elif command -v wget &>/dev/null; then
    configuredClient="wget"
  elif command -v http &>/dev/null; then
    configuredClient="httpie"
  else
    echo "Error: This tool requires either curl, wget, or httpie to be installed." >&2
    return 1
  fi
}

# Allows to call the users configured client without if statements everywhere
# TODO return false if code is not 20x
http_method() {
  local METHOD=$1; shift
  local header_opt; local header; local data_opt
  case "$configuredClient" in
    curl)   [[ -n $token ]] && header_opt="--header" header="Authorization: token $token"
      [[ $METHOD =~ (POST|PATCH) ]] && data_opt='--data'
      curl -X "$METHOD" -A curl -s $header_opt "$header" $data_opt ${HEADER:+-D $HEADER} "@$http_data" "$@" ;;
    wget)   [[ -n $token ]] && header_opt="--header" header="Authorization: token $token"
      [[ $METHOD =~ (POST|PATCH) ]] && data_opt='--body-file'
      wget --method="$METHOD" -qO- $header_opt "$header" $data_opt "$http_data" "$@" ;;
    httpie) [[ -n $token ]] && header="Authorization:token $token"
      [[ $METHOD =~ (POST|PATCH) ]] && data_opt="@$http_data"
      http -b "$METHOD" "$@" "$header" "$data_opt" ;;
  esac 2>&1 \
  | tee $(tmp_file HTTP.$METHOD) \
  || { echo "Error: no active internet connection" >&2; return 1; }
}

# Parse JSON from STDIN with string of python commands
_process_json() {
    PYTHONIOENCODING=utf-8 \
    python -c "from __future__ import print_function; import sys, json; $1"
    return "$?"
}

# Handle configuration cases
_configure() {
  [[ $# == 0 ]] && ${EDITOR} $CONFIG && return 0

  local key=$1; local value="$2"; valid_configs=${VALID_CONFIGS[@]}
  [[ ! ${key} =~ ^(${valid_configs// /|})$ ]] \
  && echo "Not a valid key for configuration, use <${valid_configs[@]// /|}> instead." \
  && return 1

  case $key in
    user)
      while [[ ! $value =~ ^[[:alnum:]]+$ ]]; do
        [[ -n $value ]] && echo "Invalid username"
        read -r -p "Github username: " value </dev/tty
      done ;;
    token)
      [[ -n $value && ${#value} -ne 40 && ! $value =~ ^(\$|\`) ]] && echo 'Invalid token format, it is not 40 chars' >&2 && return 1 ;;
    action)
      value="'$2'"
  esac

  eval $key="$value"
  echo $key="$value" >>$CONFIG
}

# Prompt for token
# TODO check token scope contains gist, ref: https://developer.github.com/v3/apps/oauth_applications/#check-a-token
_ask_token() {
  echo -n "Create a new token from web browser? [Y/n] "
  read -r answer < /dev/tty
  if [[ ! $answer =~ ^(N|n|No|NO|no)$ ]]; then
    python -mwebbrowser https://github.com/settings/tokens/new?scopes=gist
  fi

  while [[ ! $token =~ ^[[:alnum:]_-]{40,}$ ]]; do
    [[ -n $token ]] && echo "Invalid token"
    read -r -p "Paste your token here (Ctrl-C to skip): " token </dev/tty
  done

  echo token=$token >>$CONFIG
}

# Check configuration is fine with user setting
_validate_config() {
  [[ $1 =~ ^(c|config|h|help|u|user|update) ]] && return 0
  if [[ -z $user ]]; then
    echo 'Hi fellow! To access your gists, I need your Github username'
    echo "Also a personal token with scope which allows \"gist\"!"
    echo
    _configure user && _ask_token && init=true
  elif [[ -z $token && $1 =~ ^(n|new|e|edit|D|delete)$ ]]; then
    echo 'To create/edit/delete a gist, a token is needed' >&2 && return 1
    _ask_token
  elif [[ -z $token && $1 =~ ^(f|fetch)$ && $2 =~ ^(s|star)$ ]]; then
    echo 'To get user starred gists, a token is needed' >&2 && return 1
    _ask_token
  fi
}

# Apply current configuration into config file
_reformat_config() {
  local line_token=$(sed -ne '/^token=/h; ${x;p}' $CONFIG); line_token=${line_token:-token=$token}
  for key in ${VALID_CONFIGS[@]}; do
    [[ $key == token ]] && echo $line_token && continue # Because format may like this: token=$(COMMAND-TO-GET-TOKEN), just leave it untouched
    local value="${!key}"; local valid_values=${CONFIG_VALUES[$key]}
    if [[ -n "$value" ]] && [[ -z $valid_values || "$value" =~ ^($valid_values)$ ]]; then
      echo -n $key="'$value'"     
      declare -g $key="$value"               # apply current value
    else
      echo -n $key=
      declare -g $key=${valid_values%%|*}  # apply the first valid value
    fi
    echo -e "${valid_values:+\t\t# Valid: $valid_values}"
  done >"$CONFIG"
}

# Load configuration
_apply_config() {
  unset ${VALID_CONFIGS[@]}
  if [[ -e $CONFIG ]]; then
    source "$CONFIG" 2>/dev/null
  else 
    umask 0077 && touch "$CONFIG"
  fi

  _validate_config "$@" || return 1
  _reformat_config

  [[ -z $folder || ! -w $(dirname "$folder") ]] && folder=~/gist && mkdir -p $folder
  INDEX=$folder/index; [[ -e $INDEX ]] || touch $INDEX
  EDITOR=${EDITOR:-$(type vim &>/dev/null && echo vim || echo vi)}

  getConfiguredClient
}

# extract trailing hashtags from description
_trailing_hashtags() {
  grep -Eo " #[$TAG_CHAR #]+$" <<<"$1" | sed -Ee "s/.* [$TAG_CHAR]+//g"
}

_color_pattern() {
  sed -Ee "s/$1/\\\e[33m\1\\\e[0m/g"
}

_pattern_pinned_tags() {
  echo '('$(sed -E 's/ /[[:space:]]|/g; s/\./[^ ]/g; s/$/[[:space:]]/' <<<"$@")')'
}

# Return git status of a given repo
# $1 for repo path, $2 for blob_code from last fetch
_check_repo_status() {
  if [[ $2 == NONE ]]; then
    return 0
  elif [[ ! -d $1 ]]; then
    if [[ $auto_sync != false ]]; then
      echo "\e[32m[cloning]\e[0m";
    else
      echo "\e[32m[Not cloned yet]\e[0m";
    fi
  else
    cd "$1" || exit 1
    # git status is not clean or working on non-master branch
    if [[ -n $(git status --short) || $(cat .git/HEAD) != 'ref: refs/heads/master' ]] &>/dev/null; then
      echo "\e[36m[working]\e[0m"
    else
      # files contents are not the same with the last time called GIST API, so warn user to call 'gist fetch'
      [[ $(_blob_code "$1") != "$2" ]] 2>/dev/null && local status="\e[31m[outdated]\e[0m"
      # current HEAD is newer than remote, warn user to call 'git push'
      [[ -n $(git cherry origin) ]] 2>/dev/null && local status="\e[31m[ahead]\e[0m"
      echo "$status"
    fi
  fi
}

# check given index is necessary to handle
_index_pattern() {
  if [[ -z "$INPUT" ]]; then 
    echo .+
  else
    echo "($(sed -Ee '/^ {5,}/ d; s/^ *//; /^$/ q' <<<"$INPUT" | cut -d' ' -f1 | xargs | tr ' ' '|'))"
  fi
}

_show_hint() {
  if [[ $display == 'tag' && -n $pin ]]; then
    local pinned_tags=( $pin )
    echo > /dev/tty
    echo Pinned tags: "${pinned_tags[*]/#/#} " > /dev/tty
  elif [[ $hint != 'false' ]]; then
    local mtime="$(mtime $INDEX | cut -d'.' -f1)"
    echo > /dev/tty
    echo "Last updated at $mtime" > /dev/tty
    echo "Run \"$NAME fetch\" to keep gists up to date, or \"$NAME help\" for more details" > /dev/tty
  fi
}

# Display the list of gist, show username for starred gist
# If hint=false, do not print hint to tty. If mark=<pattern>, filter index with regex
# If display=tag/language, print tags/languages instead or url
_print_records() {
  if [[ ! -s $INDEX ]]; then
    echo "Index file is empty, please run commands "$NAME fetch" or "$NAME create""
    return 0
  fi

  local PWD=$(pwd)
  sed -Ee "/^$mark/ !d; /^$(_index_pattern) / !d" $INDEX \
  | while read -r "${INDEX_FORMAT[@]}"; do
    local message="$(printf '%-56s' ${GIST_DOMAIN}/${gist_id})"
    if [[ $display == 'tag' ]]; then
      [[ $show_untagged == 'false' && $tags_string == ',' ]] && continue
      message="$(printf '% 45s' "${tags_string//,/ }") "
    elif [[ $display == 'language' ]]; then
      message="$(tr ',' '\n' <<< $file_array | sed -Ee 's/.+=/#/' | uniq | xargs)"
      message="$(printf '% 45s' "$message")"
    fi

    local extra="$(printf "%-4s" "$file_num $comment_num")"
    [[ $PWD == $folder/$gist_id ]] && extra="$(tput setaf 13)>>> $(tput sgr0)"
    local status=''; status=$(_check_repo_status "${folder}/${gist_id}" "$blob_code")
    [[ $index =~ ^s ]] && description="$(printf "%-12s" [${author}]) ${description}"

    raw_output="$(printf "%-4s" "$index") $message $extra ${status:+${status} }$(_color_pattern '^(\[.+\])' <<<"$description")"
    decorator=$(( $(grep -o '\\e\[0m' <<<"$raw_output" | wc -l) *9 ))
    echo -e "$raw_output" | cut -c -$(( $(tput cols) +decorator ))
  done \
  | if [[ $display == 'tag' && -n $pin ]]; then
    local pinned_tags=($pin); local pattern="$(_pattern_pinned_tags ${pinned_tags[@]/#/#})"
    echo -e "$(_color_pattern "$pattern")"
  else
    cat
  fi

  [[ -z $INPUT ]] && _show_hint || true
}

# Grep description, filename or file content with a given pattern
# TODO add option to configure case-sensitive
_grep_content() {
  if [[ -z $1 ]]; then echo 'Please give a pattern' && return 1; fi

  sed -Ee "/^$(_index_pattern) / !d" $INDEX \
  | while read -r "${INDEX_FORMAT[@]}"; do
    # grep from description
    if grep --color=always -iq "$1" <<<"$description"; then
      hint=false mark="$index " _print_records
    else
      local repo=${folder}/${gist_id}
      [[ -d $repo ]] && cd $repo || continue
      local result=$({
        # grep from filenames
        ls $repo | grep --color=always -Ei "$1"
        # grep from content of files
        # Abort error message to prevent weird file name, for example: https://gist.github.com/6057f4a3a533f7992c60
        grep --color=always -EHi -m1 "$1" * 2>/dev/null | head -1
      })

      [[ -n $result ]] && cd - >/dev/null && hint=false mark="$index " _print_records && sed -e 's/^/     /' <<<"$result"
    fi
  done
}

# Parse JSON object of the result of gist fetch
_parse_gists() {
  _process_json '
raw = json.load(sys.stdin)
for gist in raw:
  print(gist["public"], end=" ")
  print(gist["html_url"], end=" ")
  print(",".join(file["raw_url"] for file in gist["files"].values()), end=" ")
  print(",".join(file["filename"].replace(" ", "-") + "=" + str(file["language"]).replace(" ", "-") for file in gist["files"].values()), end=" ")
  print(len(gist["files"]), end=" ")
  print(gist["comments"], end=" ")
  print(gist["owner"]["login"], end=" ")
  print(gist["created_at"], end=" ")
  print(gist["updated_at"], end=" ")
  print(gist["description"])
  '
}

# Parse response from 'gist fetch' to the format for index file
_parse_response() {
  _parse_gists \
  | while read -r "${INDEX_FORMAT[@]:1:1}" html_url file_url_array "${INDEX_FORMAT[@]:5:7}"; do
    local gist_id=${html_url##*/}
    local blob_code=$(echo "$file_url_array" | tr ',' '\n' | sed -E -e 's#.*raw/(.*)/.*#\1#' | sort | cut -c -7 | paste -s -d '-' -)
    file_array=${file_array//=None/=Text}

    local hashtags_suffix="$(_trailing_hashtags "$description")"
    description="${description%"$hashtags_suffix"}"
    local hashtags="$(echo $hashtags_suffix | xargs)"
    local tags_string="${hashtags// /,}"; [[ -z $tags_string ]] && tags_string=','

    eval echo "${INDEX_FORMAT[@]/#/$}"
  done
}

# Get a single JSON object of gist from response, and update index file
_update_gist() {
  local record="$(sed -e '1 s/^/[/; $ s/$/]/' | index=$1 _parse_response)"
  [[ -n $record ]] && sed -i'' -Ee "/^$1 / s^.+^$record^" $INDEX
}

# Get latest list of gists from Github API
_fetch_gists() {
  local route=${route:-users/$user/gists}
  if [[ $mark == s ]]; then
    route='gists/starred'
  fi

  # set global variable HEADER in http_method, so prevent using pipe
  HEADER=$(tmp_file HEADER) 
  http_method GET $GITHUB_API/$route${1} | _parse_response
}

# consider if HEADER is not exist
_fetch_gists_with_pagnation() {
  _fetch_gists "?per_page=$per_page" >> $1

  while true; do
    local next_page=''
    [[ -e $HEADER ]] && next_page=$(sed -Ene '/^[lL]ink: / s/.+page=([[:digit:]]+)>; rel=\"next\".+/\1/p' $HEADER)
    [[ -z $next_page ]] && break
    [[ $hint != false ]] && printf "%-4s gists fetched\n" $(( ($next_page -1) * $per_page )) >/dev/tty

    _fetch_gists "?per_page=$per_page&page=$next_page" >> $1 
  done || return 1
}

# Update index file by GITHUB API with pagnation
_update_gists() {
  echo "Fetching $user's gists from $GITHUB_API..."
  echo

  local fetched_records=$(tmp_file fetched)
  _fetch_gists_with_pagnation $fetched_records || { echo Something screwed; exit 1; }

  [[ ! -s $fetched_records ]] && echo 'Not a single valid gist' && return 0
  sed -i'' -Ee "/^$mark/ d" $INDEX

  extra='s0 True b0d2e7e67aa50298fdf8111ae7466b56 #bash,#gist 0316236-13154b2-768f3e5 README.md=Markdown,gist=Shell,test.bats=Shell 3 30 typebrook 2019-12-26T06:49:40Z 2021-05-05T09:42:00Z A bash script for gist management'
  [[ $mark == s ]] && echo $extra >> $INDEX

  <$fetched_records tac | nl -s' ' \
  | while read -r "${INDEX_FORMAT[@]:0:2}" extra; do
    local prefix=''
    [[ $public == False ]] && prefix=p; [[ $mark == s ]] && prefix=s
    echo $prefix$index $public $extra
  done >> $INDEX

  _print_records
  [[ $auto_sync != false ]] && (_sync_repos &> /dev/null &)
  true
}

# Fetch gists for a given user
_query_user() {
  local fetched_records=$(tmp_file fetched)
  route=users/$1/gists _fetch_gists_with_pagnation $fetched_records
  <$fetched_records tac | nl -s' ' \
  | while read -r ${INDEX_FORMAT[@]}; do
    echo $index ${GIST_DOMAIN}/${gist_id} $author $file_num $comment_num $description | cut -c -"$(tput cols)"
  done || { echo "Failed to query $1's gists"; exit 1; }
}

# Return the unique code for current commit, to compare repo status and the result of 'gist fetch'
# Because there is no way to get commit SHA with 'gist fetch'
_blob_code() {
  cd "$1" && git ls-tree master | cut -d' ' -f3 | cut -c-7 | sort | paste -sd '-'
}

_pull_if_needed() {
  sed -ne "/$1 / p" "$INDEX" \
  | while read -r "${INDEX_FORMAT[@]}"; do
    local repo; repo=$folder/$1
    local blob_code_local; blob_code_local=$(_blob_code "$repo")
    cd "$repo" \
    && [[ $blob_code_local != "$blob_code" ]] \
    && [[ $(git rev-parse origin/master) == $(git rev-parse master) ]] \
    && git pull &
  done
}

# Update local git repos
_sync_repos() {
  comm -1 <(ls -A "$folder" | sort) \
          <(while read -r ${INDEX_FORMAT[@]}; do echo $index $gist_id; done < "$INDEX" | sed -ne "/^$mark/ p" | cut -d' ' -f2 | sort) \
  | {
    result=$(cat)

    # clone repos which are not in the local
    sed -ne '/^\t/ !p' <<<$result \
    | xargs -I{} --max-procs 8 git clone "$(_repo_url {})" $folder/{} &

    # if repo is cloned, do 'git pull' if remote repo has different blob objects
    sed -ne '/^\t/ s/\t//p' <<<$result \
    | while read GIST_ID; do
      _pull_if_needed $GIST_ID
    done
  }
}

# Get the url where to clone repo, take user and repo name as parameters
_repo_url() {
  if [[ $protocol == 'ssh' ]]; then
    echo "git@gist.github.com:$1.git"
  else
    echo "${GIST_DOMAIN}/$1.git"
  fi
}

# Get gist id from index files
_gist_id() {
  read -r ${INDEX_FORMAT[@]} <<<"$(sed -ne "/^$1 / p" $INDEX)"
  GIST_ID=${gist_id}

  if [[ -z $GIST_ID || ! $1 =~ [0-9a-z]+ ]]; then
    echo -e "$(hint=false _print_records | sed -Ee 's/^( *[0-9a-z]+)/\\e[5m\1\\e[0m/')"
    echo
    echo -e "Invalid index: \e[33m$1\e[0m"
    echo 'Use the indices blinking instead (like 1 or s1)'
    return 1
  fi
}

# set gist id either by given index or current directory
_set_gist_id() {
  if [[ -z $1 ]]; then
    [[ $(dirname $(pwd)) == $folder ]] && GIST_ID=$(basename $(pwd)) && return 0
  fi
  _gist_id "$1" || return 1
}

# Show path of repo by gist ID, and perform action
_goto_gist() {
  echo "${folder}/${GIST_ID}"
  touch "${folder}/${GIST_ID}"

  if [[ $* =~ (-n|--no-action) || $PIPE_TO_SOMEWHERE == true ]]; then
    return 0
  elif [[ -z $action ]]; then
    action='echo You are in a subshell now, press \<CTRL-D\> to exit; echo; ls; ${SHELL:-bash}'
  fi

  cd "${folder}/${GIST_ID}" && eval "$action"
}

# Return the path of local repo with a given index
_goto_gist_by_index() {
  [[ $1 =~ (-n|--no-action) ]] && set -- $2 -n # move '-n' as the last argument
  _gist_id "$1" || return 1

  if [[ ! -d $folder/$GIST_ID  ]]; then
    echo 'Cloning gist as repo...'
    if git clone "$(_repo_url "$GIST_ID")" "$folder/$GIST_ID"; then
      echo 'Repo is cloned' > /dev/tty
    else
      echo 'Failed to clone the gist' > /dev/tty
      return 1
    fi
  fi

  _goto_gist "$@"
}

# Delete gists with given indices
# Specify --force to suppress confirmation
_delete_gist() {
  if [[ ! $* =~ '--force' ]]; then
    read -n1 -p "Delete gists above? [y/N] " response
    response=${response,,}
    [[ ! $response =~ ^(y|Y)$ ]] && return 0 || echo
  fi

  for i in "$@"; do
    _gist_id "$i" &> /dev/null || continue
    http_method DELETE "$GITHUB_API/gists/${GIST_ID}" \
    && echo "$i is deleted, but the local git repo is still at $folder/${GIST_ID}" \
    && sed -i'' -Ee "/^$i / d" $INDEX
  done
}

# Remove repos which are not in index file anymore
_clean_repos() {
  comm -23 <(find $folder -maxdepth 1 -type d | sed -e '1d; s#.*/##' | sort) \
           <(while read -r ${INDEX_FORMAT[@]}; do echo $gist_id; done < "$INDEX" | sort 2> /dev/null ) \
  | while read -r dir; do
    mkdir -p /tmp/gist
    mv $folder/"$dir" /tmp/gist/ && echo $folder/"$dir" is moved to /tmp/gist/
  done
}

# Parse JSON object of gist user comments
_parse_comment() {
  _process_json '
raw = json.load(sys.stdin);
for comment in raw:
    print()
    print("|", "user:", comment["user"]["login"])
    print("|", "created_at:", comment["created_at"])
    print("|", "updated_at:", comment["updated_at"])
    print("|", comment["body"])
  '
}

# Show the detail of a gist
# TODO add parameter --comment to fetch comments
_show_detail() {
  _set_gist_id $1 || return 1

  sed -En -e "/[^ ]+ [^ ]+ ${GIST_ID} / {p; q}" $INDEX \
  | while read -r "${INDEX_FORMAT[@]}"; do
    echo -e Desc: $(_color_pattern '^(\[.+\])' <<<"$description")
    echo -e Tags: ${tags_string//,/ }
    echo -e Site: ${GIST_DOMAIN}/${GIST_ID}
    echo -e APIs: https://api.github.com/gists/${GIST_ID}
    echo -e created_at: $created_at
    echo -e updated_at: $updated_at
    echo -e files:
    tr ',' '\n' <<<${file_array//=/ } | column -t | sed -e 's/^/    /'
  done
}

# Open Github repository import page
_export_to_github() {
  _gist_id "$1" || return 1
  echo Put the folowing URL into web page:
  echo -n "${GIST_DOMAIN}/${GIST_ID}.git"
  python -mwebbrowser https://github.com/new/import
}

_id_to_index() {
  while read -r ${INDEX_FORMAT[@]}; do
    [[ ! $index =~ s && ${gist_id} == $1 ]] && echo $index
  done <$INDEX
}

# Simply commit current changes and push to remote
_push_to_remote() {
  _set_gist_id $1 || return 1
  cd "${folder}/${GIST_ID}"

  local index=$(_id_to_index ${GIST_ID})

  if [[ -n $(git status --short) ]]; then
    git add . && git commit -m 'update'
  fi
  if [[ -n $(git cherry) ]]; then
    git push origin master && \
    http_method GET "$GITHUB_API/gists/${GIST_ID}" | _update_gist $index
  fi
}

# Set filename/description/permission for a new gist
_set_gist() {
  files=()
  description=''; filename=''; public=True
  while [[ -n "$*" ]]; do case $1 in
    -d | --desc)
      description="$2"
      shift; shift;;
    -f | --file)
      filename="$2"
      shift; shift;;
    -p)
      public=False
      shift;;
    *)
      files+=($1)
      shift;;
    esac
  done
  ls "${files[@]}" > /dev/null || return 1
}

# Let user type the content of gist before setting filename
_new_file() {
  tmp_file=$(tmp_file CREATE)
  if [[ -z $INPUT ]]; then 
    echo "Type a gist. <Ctrl-C> to cancel, <Ctrl-D> when done" > /dev/tty
    cat > "$tmp_file"
  else
    echo "$INPUT" > "$tmp_file"
  fi

  echo > /dev/tty
  [[ -z $1 ]] && read -e -r -p 'Type file name: ' filename < /dev/tty
  mv "$tmp_file" $tmp_dir/"$filename"
  echo $tmp_dir/"$filename"
}

# Parse JSON object of a single gist 
_gist_body() {
  _process_json "
import os.path
files_json = {}
files = sys.stdin.readline().split()
description = sys.stdin.readline().replace('\n','')
for file in files:
    with open(file, 'r') as f:
        files_json[os.path.basename(file)] = {'content': f.read()}
print(json.dumps({'public': $public, 'files': files_json, 'description': description}))
  "
}

# Create a new gist with files. If success, also update index file and clone the repo
_create_gist() {
  _set_gist "$@" || return 1
  [[ -z ${files[*]} ]] && files+=($(_new_file "$filename"))
  [[ -z $description ]] && read -e -r -p 'Type description: ' description < /dev/tty
  local index=$([[ $public == False ]] && echo p)$(( $(sed -e '/^s/ d' $INDEX | wc -l) +1 ))

  echo 'Creating a new gist...'
  http_data=$(tmp_file PATLOAD.CREATE)
  echo -e "${files[*]}\n$description" \
  | _gist_body > "$http_data" \
  && http_method POST $GITHUB_API/gists \
  | sed -e '1 s/^/\[/; $ s/$/\]/' \
  | index=$index _parse_response \
  | tee -a $INDEX \
  | while read -r "${INDEX_FORMAT[@]}"; do
    git clone "$(_repo_url $gist_id)" ${folder}/${gist_id}
  done

  # shellcheck disable=2181
  if [[ $? -eq 0 ]]; then
    echo 'Gist is created'
    INPUT=$(tail -1 $INDEX | cut -d' ' -f1) hint=false _print_records
  else
    echo 'Failed to create gist'
  fi
}

# Update description of a gist
_edit_gist() {
  local index=$1; shift
  _gist_id "$index" || return 1

  if [[ -z "$@" ]]; then
    read -r "${INDEX_FORMAT[@]}" <<<"$(sed -ne "/^$index / p" $INDEX)"
    read -e -p 'Edit description: ' -i "$description" -r DESC < /dev/tty
    tags=( ${tags_string//,/ } )
    DESC="$DESC ${tags[*]}"
  else
    DESC="$@"
  fi

  http_data=$(tmp_file PAYLOAD.EDIT)
  echo '{' \"description\": \""${DESC//\"/\\\"}"\" '}' > "$http_data"

  http_method PATCH "${GITHUB_API}/gists/${GIST_ID}" | _update_gist $index \
  && hint=false mark="$index " _print_records \
  || echo 'Fail to modify gist description'
}

# Print helper message
usage() {
  sed -Ene "/^#/ !q; 1,/^# --/ d; s/^# //p; s/^( *|Usage: )gist/\1$NAME/" "$0"
}

# Check remote urls of all repos match current protocol in configuration file
# If not, update them
_check_protocol() {
  find $folder -maxdepth 1 -mindepth 1 -type d \
  | while read -r repo; do
    cd "$repo" || exit 1
    git remote set-url origin $(_repo_url $(basename $(pwd)))
  done
}

_tag_gist() {
  # if no tag is given, show gist list with tags
  if [[ -z $* ]]; then
    display=tag _print_records
  # if user want to change tags of a gist
  elif _gist_id $1 &>/dev/null; then
    _show_detail $1 | sed 3,6d && echo
    read -r "${INDEX_FORMAT[@]}" <<<"$(sed -ne "/^$1 / p" $INDEX)"
    local tags="$(sed -e 's/,//g; s/#/ /g; s/^ //g' <<<"$tags_string")"
    read -e -p 'Edit tags: ' -i "$tags" -r -a new_tags < /dev/tty
    local hashtags=( $(sed -Ee 's/#+/#/g' <<<${new_tags[@]/#/#}) ) 
    ($0 edit $1 "${description}${hashtags:+ }${hashtags[@]}" &>/dev/null &)
  # if user want to filter gists with given tags
  else
    local pattern="($(sed -E 's/([^ ]+)/#\1/g; s/ /[[:space:]]|/g; s/\./[^ ]/g' <<<"$@") )"
    hint=false mark=${INPUT:+.} display=tag _print_records | grep --color=always -E "$pattern"
  fi
}

# show all tags and pinned tags
_show_tags() {
  local pinned_tags=( $pin )
  local pattern=$(_pattern_pinned_tags "${pinned_tags[@]/#/#}")
  local tags=$(while read -r "${INDEX_FORMAT[@]}"; do
                 echo ${tags_string//,/ }
               done < $INDEX  | tr ' ' '\n' | sed -e '/^$/d' | sort -u) 

  for prefix in {0..9} {a..z} {A-Z} [^0-9a-zA-Z]; do
    local line=$(echo $tags | grep -Eo "#$prefix[^ ]+" | tr '\n' ' ')
    [[ -z $line ]] && continue

    # add color to pinned tags
    echo -e $(_color_pattern "$pattern" <<<"$line")
  done

  echo
  if [[ ${#pinned_tags} == 0 ]]; then
    echo "Run \"$NAME pin <tag1> <tag2>...\" to pin/unpin tags"
  else
    echo Pinned tags: "${pinned_tags[@]/#/#}"
  fi
}

# pin/unpin tags
_pin_tags() {
  # if no arguments, print gists with pinned tags
  if [[ -z $* && -n $pin ]]; then
    hint=false _tag_gist $pin
  else
    local new_pinned=( $(echo $pin $* | tr ' ' '\n' | sort | uniq -u | xargs) )
    for tag in "${new_pinned[@]}"; do
      if [[ $tag =~ [p]*[0-9]+ ]]; then 
        echo Invalid tag: $tag
        return 1
      fi
    done || exit 1

    pin="${new_pinned[@]}"
    _show_tags
    sed -i'' -e "/^pin=/ d" "$CONFIG" && echo pin=\'"${new_pinned[*]}"\' >> "$CONFIG"
  fi
}

# show languages of files in gists
_gists_with_languages() {
  local pattern="($(sed -E 's/([^ ]+)/#\1/g; s/ /|/g' <<<"$@"))"
  display=language _print_records | grep --color=always -Ei "$pattern"
}

_gists_with_range() {
  [[ ! $* =~ ^s?[0-9]*-s?[0-9]*$ ]] && echo 'Invalid range' && exit 1
  local prefix=''; [[ $* =~ s ]] && prefix=s

  local maximum=$(sed -Ene "/^${prefix:-[^s]}/ p" $INDEX | wc -l)
  local range=$(sed -Ee "s/s//g; s/^-/1-/; s/-$/-$maximum/; s/-/ /" <<< "$*")
  INPUT=$(seq $range | sed -e "s/^/p?$prefix/")
  hint=false _print_records
}

_access_last_index() {
  GIST_ID=$(ls -tup $folder | grep / | head -1)
  _goto_gist "$@"
}

_apply_config "$@" || exit 1
if [[ $init ]]; then _update_gists; exit 0; fi
shopt -s extglob
case "$1" in
  "")
    _print_records ;;
  star | s)
    mark=s; _print_records ;;
  all | a)
    mark=.; _print_records ;;
  fetch | f)
    [[ $2 =~ ^(s|star)$ ]] && mark=s || mark=[^s]
    _update_gists ;;
  new | n)
    shift
    _create_gist "$@" ;;
  edit | e)
    shift
    _edit_gist "$@" ;;
  sync | S)
    _sync_repos ;;
  detail | d)
    shift
    _show_detail "$@" ;;
  id)
    shift
    _set_gist_id "$1" && echo ${GIST_ID} ;;
  url)
    shift
    _set_gist_id "$1" && echo https://gist.github.com/${GIST_ID} ;;
  delete | D)
    shift
    _delete_gist "$@" ;;
  clean | C)
    _clean_repos ;;
  config | c)
    shift
    _configure "$@" && _apply_config && sed -ne "/^$1=/p" $CONFIG && (_check_protocol &>/dev/null &) ;;
  user | u)
    shift
    _query_user "$@" ;;
  grep | g)
    shift
    _grep_content "$@" ;;
  github | G)
    shift
    _export_to_github "$1" ;;
  push | P)
    shift
    _push_to_remote "$1" ;;
  tag | t)
    shift
    _tag_gist "$@" ;;
  tags | tt)
    _show_tags ;;
  pin | p)
    shift
    _pin_tags "$@" ;;
  lan | l)
    shift
    _gists_with_languages "$@" ;;
  *([s0-9])-*([s0-9]))
    mark=.; _gists_with_range "$@" ;;
  last | L)
    _access_last_index "$@" ;;
  help | h)
    usage ;;
  *)
    _goto_gist_by_index "$@" ;;
esac
