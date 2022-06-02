if [ -z "$(which zsh)" ]; then 
    apk add zsh 
fi
export LYNS_PORTABLE_PRODIMG="xparadigm/lyns:0.9.67"
export HISTSIZE=10000
export SAVEHIST=10000
export HOMEPATH="/home/node/.shellship"
export HISTFILE="/home/node/.zsh_history"
export EDITOR="vim"
export PATH="$HOME/.deno/bin:$PATH" # add deno
export NPM_PACKAGES="$HOME/.npm/packages"
export PATH="$NPM_PACKAGES/bin:$PATH"
export DO_NOT_TRACK=1
export USER_FORCE="node"
export S9_QUIET=true
export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP

bindkey -e
bindkey "^[[3~" delete-char
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"

lyns_envset() {

    # handle .env and create system message function
    mkdir -p $HOMEPATH
    export usr=$USER_FORCE
    export usrdir="/home/$usr"
    export cfgdir="$usrdir/.config"
    export bindir_priv="$cfgdir/.bin"
    export bindir_pub="$cfgdir/bin"
    export shipdir="$usrdir/.config"
    export artdir="$cfgdir/ascii/artwork"
    export ascii="$cfgdir/ascii"
    export srcdir="$cfgdir/src"
    export coredir="$srcdir/zsh.core"
    export fishdir="$srcdir/fish"
    export fish="$srcdir/fish"
    export dist="$srcdir/distributions"
    export lynsdir="$srcdir/lyns"
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

lyns_dotenv() {
    touch "${HOMEPATH}/.env.encrypt"
    echo "CRYPTOMINTS_INTERNAL_API=localhost:1982" >> "${HOMEPATH}/.env.encrypt"
}

lyns_omz() {
    mkdir -p "${HOMEPATH}/.fonts"
    curl -Lo- https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf > ./.fonts/mesloLGS.ttf
    curl -Lo- https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf > ./.fonts/mesloLGSbold.ttf
    curl -Lo- https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf > ./.fonts/mesloLGSitalic.ttf
    curl -Lo- https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf > ./.fonts/mesloLGSbolditalic.ttf
}

lyns_child_p10ker() {
   docker run -e TERM -e COLORTERM -e LC_ALL=C.UTF-8 -it --rm alpine sh -uec '
    apk add git zsh nano vim
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${HOMEPATH}/powerlevel10k
    echo "source ${HOMEPATH}/powerlevel10k/powerlevel10k.zsh-theme" >>${HOMEPATH}/.zshrc
    ln -s ${HOMEPATH}/.zshrc ~/.zshrc && cd ~; 
    exec zsh'
}

lyns_parent_p10ker() {

    POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
    rm -rf ${HOMEPATH}/powerlevel10k
    apk add git zsh nano vim
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${HOMEPATH}/powerlevel10k
    source ${HOMEPATH}/powerlevel10k/powerlevel10k.zsh-theme

    # replace the homepath zshrc (ShellShip) with an new one
    cp /app/_files/.zshrc ${HOMEPATH}/.zshrc
    
    # create backup
    rm /root/.zshrc.bak && cp -f /root/.zshrc /root/.zshrc.bak
    rm /root/.zshrc 
    rm /home/node/.zshrc
     
    # Link shellship zshrc as the homedir zshrc 
    ln -s ${HOMEPATH}/.zshrc /home/node/.zshrc;
    ln -s /home/node/.zshrc /root/.zshrc 
}

lyns_setup_child() {
   cd "${HOMEPATH}/"
   mkdir -p "${HOMEPATH}/child1a"
   docker run -e TERM -e COLORTERM -e LC_ALL=C.UTF-8 -it --entrypoint lyns --rm -v $PWD/child:/lyns ${LYNS_PORTABLE_PRODIMG}
}

lyns_setup_alpine() {

    cp -f /app/passwd /etc/passwd
    apk add libuser
    touch /etc/login.defs
    deluser --remove-home node
    mkdir /etc/default
    touch /etc/default/useradd
    echo "SHELL=/usr/bin/zsh" > /etc/default/useradd
    echo "SKEL=/root" >> /etc/default/useradd
    echo "HOME=/app/_files" >> /etc/default/useradd
    echo "GROUP=1005" >> /etc/default/useradd
    adduser -h /app/_files -s /usr/bin/zsh node
    lchsh node

}

lyns_setup_secrets(){
    # stubbed out secrets via cryptomint protocol
}

lyns_protocol_broker() {
    # stubbed out for API
}

lyns_setup_alpine
# configure NVM first for ZSH.  

# note:  fish has a separate config bootstrap for this.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# apply configuration to app

#-------------------------------------------------------------
lyns_envset # instantiate environment directories
lyns_dotenv # create environment and parse .env files

#-------------------------------------------------------------
lyns_setup_secrets      # soon toi be cryptomints
lyns_protocol_broker    # protocol brokering is safer than key
                        # storage, but our keyless is safer

#-------------------------------------------------------------
lyns_omz   # runs the font setup and omz setup pre-requisites,
           # except the actual omzshell script, which I prefer
           # to keep containerized since it can delete things
           # and has a tendency to go haywire (randomly due to plugins)!


# lyns_p10ker
lyns_parent_p10ker # you may inject new zshrc via /app/_files/.zshrc
                   # just replace that file, then call this function.

# bin dir created automatically 
# during the release bundler execution
# https://github.com/64b/desktop-bin

# you can do this in fish, but it is not advisable.
# but we have not instantiated fish at this point in the bootstrap
# so we are still using zsh.core
export PATH="$PATH:$bindir_priv:$bindir_pub"

# Ambient Mode Turns off Shell Notifications
if test "$S9_QUIET" = true; then
    echo "now in ambient mode. \n\n $NOTES"
fi

if test "$BASH_MODE" = true; then 
    apk add bash
    /bin/bash
    echo "now in bash modemode. \n\n $NOTES"
    # -u Treat unset variables as an error when substituting them 
    # -e Exit immediately on Error.
    # -x Print commands and their arguments as they are read  
    # -v Print shell input lines as they are read 
    # -B Perform brace expansion and
    # -n read commands but do not execute them (dry run)
    # -a mark variables which are modified or created for exporting
    args=(-u -e -x)
fi

# private user-specific vars are generally stored in a .private file and removed on exit
lyns  && [ -z "${HOMEPATH}/.private" && source "${HOMEPATH}/.private" ]
cd ~