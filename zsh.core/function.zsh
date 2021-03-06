#!/usr/bin/env lyns
# Functions.lyns in the ~/.config/src/lyns directory is the development codebase for ~/.config/lyns
#
# Working Functions Registry is housed here.  If one file breaks the idea is we won't break the whole program.
# Author: hi@lynsei.com
# 
#  What is this?
#
#  DevOps & Security functions for Lyns shell environment.
# 
#  The end goal is to have a very rich library of re-usable, declarative, easy to 
#  modularize, and quick to sort functional collections that users can make use of,
#  and that can wrap new methods to make them easier to test.   These will also work
#  deterministically and can be used in CLI plugins.

#  Some checks are place holders for rethinkDB integraton points on event signals:
function _lyns_cli_status_check
    argv=$@
    switch 
        case 'enable'
            set -x ENABLE_CLI true
        case 'disabled'
            echo "Placeholder"
    end
end
funcsave _lyns_cli_status_check


function _lyns_cli_enable
    argv=$@
    switch 
        case 'enable'
            set -x ENABLE_CLI true
            _mark && echo (_lyns_ts)
        case '*'
          set -x DISABLE_RESERVED_WORDS false
          _mark && echo (_lyns_ts)
    end
end
funcsave _lyns_cli_enable

function _lyns_mod_urandom
    argv=$@
    switch 
        case 'make'
            if assert test -d ~/.f/urandom is true
               set -x dir_entropy ~/.f/_dev/paradim/urandom
               cd ($dir_entropy)
               make
            end
        case '*'
            _lyns_alert 
    end
end
funcsave _lyns_mod_urandom

function _lyns_collect
    argv=$@
    _lyns_alert 
    echo 
end
funcsave _lyns_collect

function _lyns_invoke
    argv=$@
    switch $argv:
        case 'delay':
            echo Delay.  
        case 'perform':
             echo Events Shell.
    end
end
funcsave _lyns_invoke

function _lyns_announce
    argv=$@;
    _lyns_alert $argv;
    echo $argv;
end
funcsave _lyns_announce

function _lyns_alert
    echo "⏅sy⟗⦅‣ ✨. Alert Message __________________________________________ "
    echo "⏅sy⟗⦅‣ ✨. Sent to: $ITERM_PROFILE / $USER                          "
    echo "⏅sy⟗⦅‣ ✨. --> Now Operating $argv[1]                               " 
    echo "⏅sy⟗⦅‣ ✨.                                                          "
    echo "⏅sy⟗⦅‣ ✨. End Alert Message ______________________________________ "
    echo "⏅sy⟗⦅‣ ✨. "
end
funcsave _lyns_alert


function _lyns_abbr
    abbr -e la
    abbr -e ls
    abbr -e cd 
    abbr -e dir
    abbr -a -g -- .1 'cd $HOME/.config/src/lyns'
    abbr -a -g -- .2 'cd $HOME/.config/src/zsh.core'
    abbr -a -g -- .3 'cd $HOME/.config/src/zsh.theme'
    abbr -a -g -- .4 'cd $HOME/.config/src/zsh.methods'
    abbr -a -g -- .5 'cd $HOME/.config/src/zshrc'
    abbr -a -g -- .a 'cd $HOME/.f/all.apis'
    abbr -a -g -- .b 'cd $HOME/.f/ai-shell/clinops/branches'
    abbr -a -g -- .co 'cd $HOME/.c'
    abbr -a -g -- .cm 'cd $HOME/.f/repos.shared/pkg.core.monorepo'
    abbr -a -g -- .e 'cd $HOME/.c/bitbucket.esp.branches'
    abbr -a -g -- .i 'cd $HOME/.f/all.cli'
    abbr -a -g -- .n 'node $HOME/.config/src/node/shellship.js'
    abbr -a -g -- .r 'cd $HOME/.f/all.rust'
    abbr -a -g -- .s 'cd $HOME/.f/repos.shared'
    abbr -a -g -- .se 'cd $HOME/.f/shellenv'
    abbr -a -g -- .u 'cd $HOME/.config/user-conf'
    abbr -a -g -- .z 'cd $HOME/.Flat'
    abbr -a -g -- .a 'abbr -q'  # queries abbr
    abbr -a -g -- _abbr _lyns_abbr
    abbr -a -g -- c _lyns_widget_list
    abbr -a -g -- config_widget_cd _lyns_widget_list
    abbr -a -g -- gc 'git clone'
    abbr -a -g -- gcb 'git checkout -b'
    abbr -a -g -- gra 'git remote add'
    abbr -a -g -- grv 'git remote -v'
    abbr -a -g -- sr 'source ~/.config/src/lyns/functions.lyns && _lyns_abbr'
    abbr -a -g -- ssf 'vi $HOME/.config/src/lyns/functions.lyns'
    abbr -a -g -- sss 'source $HOME/.config/src/lyns/functions.lyns'
    abbr -g -a s9.bootstrap -- '$ZSH_CUSTOM/.setup'
    abbr -g -a s9.reload -- "source $ZSH_CUSTOM/.zshrc; lyns" 
    abbr -g -a s9.omzre -- 'source ~/.oh-my-zsh/oh-my-zsh.sh'
    abbr -g -a kube_auto -- 'complete -F __start_kubectl  k'
    abbr -g -a s9f -- "find . -name "
    abbr -g -a s9.omz -- omf
    abbr -g -a h htop
    abbr -g -a k kubectl
end
funcsave _lyns_abbr

function _lyns_reservations
    switch 
        case 'randomize'
             echo /dev/urandom | tee -a ~/.log.urandom && tail -n 1 ~/.log.urandom
             set -l reservations nopassword_login_username crypto_algorithm_enforced_minimum
             _mark && echo (_lyns_ts)
        case '*'
            set -x DISABLE_RESERVED_WORDS false
            _mark && echo (_lyns_ts)
    end
end
funcsave _lyns_reservations

function _lyns_widget_list  
    fzf -0 -1 --ansi --header="⏅sy⟗⦅‣ shell ✨"
    ls -laF $argv[1] && clear && pwd
 end
 funcsave _lyns_widget_list

function _lyns_widget_cd
    fzf-cd-widget --ansi --header="⏅sy⟗⦅‣ shell ✨"
    cd $argv[1] && clear && pwd
 end
 funcsave _lyns_widget_cd

 function _lyns_ts
    echo (date +%y-%m-%d-%h-%M-%s)
 end
 funcsave _lyns_ts

 function _lyns_export
    cat ~/.config/lyns/lyns_variables > ~/.backup/_variables.lyns
    cat ~/.config/lyns/functions/*.lyns > ~/.backup/_functions.lyns
    cat ~/.config/lyns/*.lyns > ~/.backup/_config.lyns
    cat ~/.config/lyns/completions/*.lyns > ~/.backup/_completions.lyns

    cat ~/.config/lyns/lyns_variables > ~/.config/.config.export/_variables.lyns
    cat ~/.config/lyns/functions/*.lyns > ~/.config/.config.export/_functions.lyns
    cat ~/.config/lyns/*.lyns > ~/.config/.config.export/_config.lyns
    cat ~/.config/lyns/completions/*.lyns > ~/.config/.config.export/_completions.lyns

    cp -rf ~/.config/lyns/cli ~/.config/.config.export/lyns/cli
    cp -f ~/.config/.config.fat/shellenv.toml ~/.config/.config.export/shellenv.tom

    echo "Lyns and CLI Short-Configuration (most critical functions) exported successfully!"
end; funcsave _lyns_export

function _export 
    if ! test -d /Users/$USER/.config/.config.export/lyns/cli
        mkdir -p /Users/$USER/.config/.config.export/lyns/cli
        if ! test -f /Users/$USER/.config/.config.export/shellenv.toml
            touch $HOME/.config/.config.export/shellenv.toml
        end
    end
    _lyns_export $argv 
end; funcsave _export
