# -*- shell-script -*-

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

if [ -f /usr/local/share/config/term_colors ]; then
  source /usr/local/share/config/term_colors
fi

export PAGER='most'

export HISTFILESIZE=1000
export HISTSIZE=1000

# Make sure that all terminal sessions append to history file.
shopt -s histappend

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
#export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Work around for Google Chrome not accepting keyboard input in addressbar
# https://bugs.launchpad.net/ubuntu/+source/chromium-browser/+bug/1307648
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export CLUTTER_IM_MODULE=ibus

# Fix for running swing app under awesome
#export AWT_TOOLKIT=MToolkit

# Fix for Java under Ubuntu Hardy
#export LIBXCB_ALLOW_SLOPPY_LOCK=1

# need to install ncurses-term
export TERM=xterm-256color
[ -n "$TMUX" ] && export TERM=screen-256color

export BROWSER=w3m

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

host=`hostname`
if [ $host = olethros ] ; then
  export MAILDIR=~/Maildir/tickit
elif [ $host = teleute ] ; then
  export MAILDIR=~/Maildir/colbaibell.org
fi

# Colored man pages
#export LESS_TERMCAP_mb=$'\E[01;31m' # begin blinking
#export LESS_TERMCAP_md=$'\E[01;38;5;74m' # begin bold
#export LESS_TERMCAP_me=$'\E[0m' # end mode
#export LESS_TERMCAP_se=$'\E[0m' # end standout-mode
#export LESS_TERMCAP_so=$'\E[38;5;246m' # begin standout-mode - info box export LESS_TERMCAP_ue=$'\E[0m' # end underline
#export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_colored_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
      else
    color_prompt=
  fi
fi

#color_prompt=yes

#if [ "$color_prompt" = yes ]; then
#    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#    PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w\[\033[31m\]$(__git_ps1 " %s") \[\033[01;34m\]$\[\033[00m\] '
#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi
#unset color_prompt force_color_prompt


function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo " !"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[git: \1$(parse_git_dirty)]/"
}

hg_ps1() {
  #hg prompt "[hg: {[+{incoming|count}]-->}{root|basename}{/{branch}}{-->[+{outgoing|count}]}{status}]" 2> /dev/null
  hg prompt "[hg: {{branch}}{status}]" 2> /dev/null
}
#export PS1="$(hg_ps1) $PS1"

export PS1='\u@\h \[\033[1;34m\]\w\[\033[0m\] $(parse_git_branch)$(hg_ps1)'

if [ -x ~/.rvm/bin/rvm-prompt ]; then
  export PS1="$PS1 [\$(~/.rvm/bin/rvm-prompt)]"
fi

export PS1="$PS1$ "
# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# From http://archlinux.me/crouse/2011/05/10/bash-some-bashrc-functions/
# hs() {
#   history | grep ${1} | uniq --skip-fields=1 | sort -biz | uniq --skip-fields=2
# }
# clock ()
# {
#   while true;do clear;echo “===========”;date +”%r”;echo “===========”;sleep 1;done
# }

#######################################################################


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    .  ~/.bash_aliases
fi

# Emacs setup.
#if [ -f ~/.bashrc_emacs ]; then
#    .  ~/.bashrc_emacs
#fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
# if [ -f $rvm_scripts_path/rvm-completion.rb ]; then
#   complete -C $rvm_scripts_path/rvm-completion.rb -o default rvm
# fi
[[ -r $rvm_path/scripts/completion ]] && . $rvm_path/scripts/completion

# Source global definitions
if [ -f /usr/local/share/config/dhammapada ]; then
  source /usr/local/share/config/dhammapada
fi
