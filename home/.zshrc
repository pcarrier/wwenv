#!/bin/zsh

[ -n "$PROFILED" ] || . ~/.zprofile

disable -r time

zmodload -a autocomplete
autoload -U age && age
autoload -Uz compinit && compinit
setopt interactivecomments
setopt autocd autopushd pushdminus pushdsilent pushdtohome
setopt HIST_REDUCE_BLANKS HIST_IGNORE_SPACE SHARE_HISTORY HIST_FCNTL_LOCK inc_append_history
setopt no_clobber print_exit_value #no_hup
setopt extendedglob glob_dots
setopt correct
setopt no_complete_aliases
setopt prompt_subst
autoload -U colors && colors

bindkey -e
bindkey '^[[1;5C' emacs-forward-word
bindkey '^[[1;5D' emacs-backward-word

PS1_SEP="%{$fg_no_bold[white]%}"$'\ue0b1'
#PS1_SEP="%{$fg_no_bold[white]%}"$'\u27e9'

branch() {
  b=$(git symbolic-ref --short HEAD 2>/dev/null | sed 's/^pcarrier/~/')
  [[ -n "$b" ]] && print -n "${b}$PS1_SEP"
}

PS1="%(0?..%{$fg_no_bold[red]%}%?$PS1_SEP)"\
"%(1j.%{$fg_no_bold[yellow]%}%j$PS1_SEP.)"\
"%{$fg_no_bold[green]%}%~$PS1_SEP"\
"%{$fg_no_bold[yellow]%}%20<…<\$(branch)%<<"\
"%{$reset_color%}"

title() {
  local a=${(V)1//\%/\%\%}
  a=$(print -Pn "%30>…>$a"|tr -d "\n")
  case $TERM in
    screen*)
      print -Pn "\e]2;$a (%~)\a" # plain xterm title
      print -Pn "\ek$a (%~)\e\\" # screen title (in ^A")
    ;;
    xterm*|rxvt*|cygwin)
      print -Pn "\e]0;$a (%~)\a"
    ;;
  esac
}
function precmd() { title "zsh" }
function preexec() { title "$1" }

lf()   { awk -F '{print $NF;}'; }
mkcd() { mkdir -p "$1"; cd "$1"; }
sp()   { curl -F 'sprunge=<-' http://sprunge.us; }

gcd() { local p="$HOME/repos/${1:t:r}"; [[ ! -e "$p" ]] && git clone "$1" "$p"; cd "$p" }
ghcd() { gcd "git@github.com:$1"; }
pcd()  { ghcd "pcarrier/$1"; }
mcd()  { ghcd "mdg-private/$1"; }
acd()  { ghcd "apollographql/$1"; }

alias ls='ls -liF --color=auto'
alias dl='aria2c --force-sequential --continue -j16 -x16 --stream-piece-selector=inorder --min-split-size=1M'

alias gr='git rebase'
alias grc='git rebase --continue'
alias gri='git rebase --interactive'
alias gra='git rebase --abort'
grf()  { git show $(<.git/rebase-merge/stopped-sha); }

alias kl='time kubectl'
alias kld='time kubectl --namespace pcarrier'
alias klk='time kubectl --namespace kube'
alias kls='time kubectl --namespace staging'
alias klp='time kubectl --namespace prod'
alias klP='time kubectl --namespace prodperf'
alias G="time $HOME/repos/monorepo/gradlew"

g() { suffix="$1"; shift; "galaxy${suffix}" "$@"; }

hash -d m="$HOME/repos/monorepo"

eval "$(direnv hook zsh)"
