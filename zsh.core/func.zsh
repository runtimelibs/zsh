#!/usr/bin/env zsh
function install_docker() {
   declare -x docker_brew=docker(
    'brew unlink docker docker-completion docker-compose docker-compose-completion'
    'brew unlink docker-ls dockerize docker-clean docker-gen docker-toolbox'
    'brew install docker docker-completion docker-compose docker-compose-completion'
    'brew install docker-ls dockerize docker-clean docker-gen docker-toolbox'
  )
  for d in $docker_brew; do eval $d; done
}

# docker testing functions
function get_docker() {
        install_docker
        echo "Docker has now been installed properly."
        yarn global add "$@" --prefix /usr/local/bin
        which "$@"
}

function docker_exists() {
    if hash docker 2>/dev/null; then
        docker "$@"
    else
        get_docker "$@"
    fi
}


# build directory generator for new docker images from sub modules
function build_path() {
     (mkdir -p $ZSH_CUSTOM/.build/.config && 
     mkdir -p $ZSH_CUSTOM/.build/.images &&
     mkdir -p $ZSH_CUSTOM/.buiild/.modules &&
     mkdir -p $ZSH_CUSTOM/.build/.shells )
}

function alpine_git() {
    (docker run -ti --rm -v ${HOME}:/root -v $(pwd):/git alpine/git "$@")
}


# test pet functionality is installed
function prev() {
  PREV=$(fc -lrn | head -n 1)
  sh -c "pet new `printf %q "$PREV"`"
}


function install_yarn () {
    if hash yarn 2>/dev/null; then
        yarn global add "$@" --prefix /usr/local/bin
        which "$@"
    else
        echo "No Yarn.  Installing it, then the task runner completions!"
        brew install yarn 
        yarn global add "$@" --prefix /usr/local/bin
        which "$@"
    fi
}   

function is_gulp (){
    if hash gulp 2>/dev/null; then
        gulp "$@"
    elsea

        echo "installing gulp"
        npm install -g gulp gulp-cli
        is_gulp "$@"
    fi
}   

function is_grunt (){
    if hash grunt 2>/dev/null; then
        grunt "$@"
    else
        echo "installing grunt"
        npm install -g grunt grunt-cli
        is_grunt "$@"
    fi
}   