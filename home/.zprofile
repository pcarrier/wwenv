#!/bin/zsh

[[ -n $PROFILED ]] && return

export \
GOPATH=$HOME/go \
GOROOT=$HOME/opt/go \
VISUAL='subl -w' \
EDITOR='subl -w' \
MANPAGER=most \
LANG=en_DK.UTF-8 \
LC_COLLATE=C \
LC_MONETARY=en_CA.UTF-8 \
LC_PAPER=en_CA.UTF-8

export PATH=\
$HOME/bin:\
$GOPATH/bin:\
$GOROOT/bin:\
/usr/local/bin:\
/usr/local/sbin:\
/usr/bin:\
/usr/sbin:\
/bin:\
/sbin

export HISTSIZE=1048576 SAVEHIST=1048576 HISTFILE="$HOME/.history"

autoload -U colors && colors
export \
NINJA_STATUS="${fg[blue]}rem:%u run:%r fin:%f time:%e${reset_color} " \
TIME=\
"${fg_no_bold[red]}time "\
"${fg_no_bold[blue]}elapsed${reset_color}=%E "\
"${fg_no_bold[blue]}user${reset_color}=%U "\
"${fg_no_bold[blue]}system${reset_color}=%S "\
"${fg_no_bold[blue]}cpu${reset_color}=%P "\
"${fg_no_bold[red]}rss "\
"${fg_no_bold[blue]}max${reset_color}=%M\n"\
"${fg_no_bold[red]}fs "\
"${fg_no_bold[blue]}in${reset_color}=%I "\
"${fg_no_bold[blue]}out${reset_color}=%O "\
"${fg_no_bold[red]}faults "\
"${fg_no_bold[blue]}major${reset_color}=%F "\
"${fg_no_bold[blue]}minor${reset_color}=%R "\
"${fg_no_bold[red]}ctx "\
"${fg_no_bold[blue]}asked${reset_color}=%w "\
"${fg_no_bold[blue]}forced${reset_color}=%c"

test -f ~/.ssh/agent.env && . ~/.ssh/agent.env >| /dev/null
ssh-add -l >| /dev/null 2>&1
if [[ $? = 2 ]] || [[ -z "$SSH_AUTH_SOCK" ]]; then
    (umask 077; ssh-agent -s >| ~/.ssh/agent.env)
    . ~/.ssh/agent.env >| /dev/null
fi

export MONOREPO_INSTALL_DIR=$HOME/opt/mrdeps

export PROFILED=1
