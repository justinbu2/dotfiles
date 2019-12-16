# ----------------------------------------------------
# BASH Configuration File
# ----------------------------------------------------
# Default Ubuntu bashrc below. Custom configs come after.

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ===================================================================
# CUSTOM CONFIGS
# ===================================================================

# Globals -----------------------------------------------------------
COLOR_YELLOW="\033[33m"
COLOR_YELLOW_BOLD="\033[33;1m"
COLOR_RED="\033[31m"
COLOR_GREEN="\033[32m"
COLOR_CYAN="\033[34m"
COLOR_BLUE="\033[36m"
COLOR_BLUE_BOLD="\033[36;1m"
COLOR_PURPLE="\033[35m"
COLOR_WHITE="\033[39m"
NC="\033[m" # Color Reset

# Functions ---------------------------------------------------------
function psef() {
    ps -ef | grep "$1" | egrep -v grep | grep --color "$1"
}

# Get list of file descriptors used by pid
function fd() {
    ll /proc/"$1"/fd
}

# Git functions
# List and index unstaged changes
function gss() {
    unbuffer git status -s | nl # macOS: requires `brew install expect`
}

# Git operations by index in output of `gss`
function git_idx() {
    local files=$(git status -s | awk '{print $2}')
    local args=""
    for ((i=1;i<=$#;i++)); do
        if [[ ${!i} =~ ^-?[0-9]+$ && ! -f ${!i} ]]; then
            args="$args $(echo $files | awk -v n=${!i} '{print $n}')"
        else
            args="$args ${!i}"
        fi
    done
    git $args
}

# Get current branch in git repo
# Credit: jmatth from ezprompt.com
function parse_git_branch() {
    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! "${BRANCH}" == "" ]
    then
        STAT=`parse_git_dirty`
        echo "[${BRANCH}${STAT}]"
    else
        echo ""
    fi
}

# Get current status of git repo
# Credit: jmatth from ezprompt.com
function parse_git_dirty {
    status=`timeout 1 git status 2>&1 | tee` # macOS: requires `brew install coreutils`
    dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
    untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
    ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
    newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
    renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
    deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
    bits=''
    if [ "${renamed}" == "0" ]; then
        bits=">${bits}"
    fi
    if [ "${ahead}" == "0" ]; then
        bits="*${bits}"
    fi
    if [ "${newfile}" == "0" ]; then
        bits="+${bits}"
    fi
    if [ "${untracked}" == "0" ]; then
        bits="?${bits}"
    fi
    if [ "${deleted}" == "0" ]; then
        bits="x${bits}"
    fi
    if [ "${dirty}" == "0" ]; then
        bits="!${bits}"
    fi
    if [ ! "${bits}" == "" ]; then
        echo " ${bits}"
    else
        echo ""
    fi
}

last_status_color() {
    local status="$?"
    if [[ "$status" != 0 ]]; then
        echo -e "$COLOR_RED"
    else
        echo -e "$COLOR_GREEN"
    fi
}

# Exports ----------------------------------------------------------
export EDITOR=/usr/bin/vim
export HISTSIZE=10000
export HISTCONTROL=ignoredups   # Remove duplicate history commands in terminal
export PYTHONSTARTUP=~/.pythonrc

# PS1
PS1="\n"                                            # newline
PS1+="[\`last_status_color\`\t$NC] "                # timestamp
PS1+="$COLOR_RED\u@$COLOR_PURPLE\h $COLOR_RED\w$NC" # user@host:cwd
PS1+="\n"                                           # newline
PS1+="$COLOR_BLUE\`parse_git_branch\`$NC$ "         # git branch status
export PS1

# Colorize `less` colors for man pages
export LESS_TERMCAP_mb=$'\E[01;31m'     # Begin blinking
export LESS_TERMCAP_md=$'\E[01;31m'     # Begin bold
export LESS_TERMCAP_me=$'\E[0m'         # End mode
export LESS_TERMCAP_se=$'\E[0m'         # End standout-mode
export LESS_TERMCAP_so=$'\E[01;44;33m'  # Begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'         # End underline
export LESS_TERMCAP_us=$'\E[01;32m'     # Begin underline

# Add colors to ls
eval "$(dircolors -b)" # Add colors to ls. macOS: won't work
LS_COLORS+=":ow=01;32"

# Add color to terminal (macOS)
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Aliases -----------------------------------------------------------
alias ls='ls -GFh --color' # macOS: remove '--color'
alias lsc='ls'
alias l='ls'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias cd..='cd ../'
alias ..='cd ../'
alias ...='cd ../'
alias .2='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias rm='rm -iv'
alias grep='grep --color'
alias agp='ag --py' # macOS: requires `brew install ag`
alias agc='ag --cpp' # macOS: requires `brew install ag`
alias diff='colordiff' # macOS: requires `brew install colordiff`
alias less='less -FSRXcm' # -F: quit if 1 screen -S: no wordwrap -R: raw ctrl chars -X: no termcap init/de-init strs sent to term -c: repaint -m: show percentage
alias les='less'
alias lf='less +F'
alias lg='less +G'
alias u='uptime'

alias p='python'
alias p3='python3'

alias path='echo -e ${PATH//:/\\n}'         # Echo all executable Paths
mcd () { mkdir -p "$1" && cd "$1"; }        # Makes new Dir and jumps inside
ql () { qlmanage -p "$*" >& /dev/null; }    # Opens any file in MacOS Quicklook Preview
trash () { command mv "$@" ~/.Trash ; }     # Moves a file to the MacOS trash

# Git aliases
# Using git_idx function
alias gad='git_idx add'
alias gau='git_idx add -u'
alias gco='git_idx checkout'
alias gcp='git_idx checkout --patch'
alias gd='git_idx diff --color'
alias gdn='git_idx diff --name-only'
alias grh='git_idx reset HEAD'
alias gs='git_idx status'

# Vanilla
alias ga='git add -A'
alias gc='git clone'
alias gcf='git clean -f'
alias gca='git commit -a'
alias gcm='git commit -m'
alias gp='git push origin HEAD'
alias gb='git branch'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

# Misc --------------------------------------------------------------
alias proj='cd ~/proj/'
alias winproj='cd /mnt/c/Users/justinbu/proj/'
alias windesk='cd /mnt/c/Users/justinbu/Desktop/'
