#!/usr/bin/env zsh

if [[ ! $ENABLE_CLI -eq true ]]; then echo "CLI Mode disabled automatically"; exit; fi
S9_QUIET=${QUIET:-false}
S9_EXPLN="${VERBOSE:-1}"

export SHELLSHIP_SYMBOL="@"
export SHELLSHIP_CHARACTER="@"

# Private variables are the ones you can set locally but won't make it into development .git:
touch .privatevar; source .privatevar

if test "$S9_QUIET" = "false"; then
    # Package version for ShellShip shall always come from source of truth at NPM registry
    # because NPM manages ALL Node, Python, Ruby, Tilt, Go, and Rust dependencies for Shellship.
    # The following command retrieves the shellship version in a declarative manner, and 
    # should be utilized whenever you are instantiating an instance of shellship at runtime:
    #
     
fi

function lyns_envset() {

    # handle .env and create system message function
    export usr=${USER:-admin}
    export usrdir="/Users/$usr"
    export cfgdir="$usrdir/.shellship"
    export bindir="$cfgdir/.bin"
    export artdir="$cfgdir/ascii/artwork"
    export ascii="$cfgdir/ascii"
    export srcdir="$cfgdir/src"
    export coredir="$srcdir/zsh.core"
    export lynsdir="$srcdir/lyns"
    export arch="$srcdir/arch"
    export bash="$srcdir/bash"
    export lyns="$srcdir/lyns"
    export dist="$srcdir/distributions"
    export node="$srcdir/node"
    export python="$srcdir/python"
    export boot="$srcdir/bootstrap"
    export rust="$srcdir/rust"
    export xonsh="$srcdir/xonsh"
    export shellenv="$srcdir/shellenv"
    export tests="$srcdir/tests"
    export asdf="$srcdir/asdf"
    export elvish="$srcdir/elvish"
    export zshcore="$srcdir/zsh.core"
    export zshenv="$srcdir/.env"
    export methods="$srcdir/zsh.methods"
    export theme="$srcdir/zsh.theme"
    export rc="$srcdir/zshrc"
}

function lyns_dotenv() {
  touch $zshenv && \
    source $zshenv && \
    source $coredir/alert.zsh
}

function lyns_crypt() {
    KEYS_API=https://localhost
    return "d0ak30jfikda3i390-fake"
}
# configure NVM first for ZSH.  
# note:  lyns has a separate config bootstrap for this.
export NVM_DIR="$HOME/..nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# configure app .zshrc environment exports
lyns_envset # instantiate environment directories
lyns_dotenv # create environment and parse .env files
lyns_crypt "$KEYS_API/token/refresh/$REFRESH"

# bin dir created automatically 
# during the release bundler execution
# https://github.com/64b/desktop-bin

# you can do this in lyns, but it is not advisable.
# but we have not instantiated lyns at this point in the bootstrap
# so we are still using zsh.core
export PATH="$PATH:$bindir"

if test "$S9_QUIET" = true; then
    alert_sysmsg " in Ambient Mode. \n\n $NOTES"
    /usr/local/bin/lyns
fi
if ! test "$S9_QUIET" = true; then
   alert_sysmsg " in Boombox Mode. \n\n $NOTES"
   if test "$S9_EXPLN" = true; then
    /usr/local/bin/lyns
   else
    /usr/local/bin/lyns
   fi
fi

