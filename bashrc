#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#### FIG ENV VARIABLES ####
# Please make sure this block is at the start of this file.
[ -s ~/.fig/shell/pre.sh ] && source ~/.fig/shell/pre.sh
#### END FIG ENV VARIABLES ####

# Get environment variables, such as platform
#source $HOME/.dotfiles.sh

export DOTFILES_PLATFORM="$(uname -s)"

####
#
# Mac
#
####

if [ "$DOTFILES_PLATFORM" == "Darwin" ]
then
  alias ls="ls -Gp"
  alias t2mount='sudo /usr/local/bin/ntfs-3g /dev/disk2s1 /Volumes/NTFS -olocal -oallow_other'
  alias t2umount='sudo umount /Volumes/NTFS'
  #export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/texlive/2015/bin/x86_64-darwin
  #export DYLD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/lib
  #STASH="https://git.rgoffice.net/projects/NOVA/repos/nova/pull-requests?create\&sourceBranch=refs%2Fheads%2F"
  #TARGET="\&targetBranch=refs%2Fheads%2Fmaster"
  #alias pr="open $STASH\$(parse_git_branch)$TARGET"
fi

####
#
# Linux
#
####

if [ $DOTFILES_PLATFORM == "Linux" ]
then
  alias telegram="~/applications/telegram/Telegram"
  export XDG_CONFIG_HOME='~/.config'
  #xrdb -merge ~/.Xresources
  alias flux="xflux -l 55.9409861 -g -3.3454653,11"
  export LC_ALL=en_GB.UTF-8
  alias ls="ls -F --color=auto --group-directories-first"
fi

####
#
# Platform independent
#
####

parse_git_branch() {
    git symbolic-ref --short HEAD 2> /dev/null
}

get_colour() {
    if (( $( git status -s 2> /dev/null | wc -m) == 0 ));
        then  echo '32'
    else echo '31'
    fi
}

if [ -f ~/.aliases.sh ]; then
    . ~/.aliases.sh
fi

if [ -f ~/.env.sh ]; then
    . ~/.env.sh
fi

if [ -f ~/.host.sh ]; then
    . ~/.host.sh
fi


P_USERNAME="\[\033[36m\]\u\[\033[m\]"
P_HOSTNAME="\[\033[32m\]\h"
P_WORKINGDIR="\[\033[33;1m\]\w\[\033[m\]"
#P_GIT="on \[\e[\$(get_colour)m\]\$(parse_git_branch)\[\e[00m\]"
P_GIT=""
P_PROMPT="\[\033[35m\]❯\[\033[m\]"
GIT_BRANCH="\$(parse_git_branch)"
P_NAVE=""
if [ "$NAVEVERSION" != "" ]
then
  P_NAVE="(\[\e[\$(get_colour)m\]\$NAVEVERSION\[\e[00m\])"
fi

if [ "$GIT_BRANCH" != "" ]
then
  P_GIT="on \[\e[\$(get_colour)m\]\$(parse_git_branch)\[\e[00m\]"
fi

export PS1="$P_WORKINGDIR $P_GIT $P_NAVE\n$P_PROMPT "

#### FIG ENV VARIABLES ####
# Please make sure this block is at the end of this file.
[ -s ~/.fig/fig.sh ] && source ~/.fig/fig.sh
#### END FIG ENV VARIABLES ####