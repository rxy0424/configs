#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '


alias ll='ls -all'

alias grep='grep --color=auto'

. /usr/share/fzf/key-bindings.bash

export EDITOR=vim

# for TexLive
# Set MANPATH for TexLive
export MANPATH="/home/rxy/local/texlive/2024/texmf-dist/doc/man:$MANPATH"

# Set INFOPATH for TexLive
export INFOPATH="/home/rxy/local/texlive/2024/texmf-dist/doc/info:$INFOPATH"

# Set PATH for TexLive
export PATH="/home/rxy/local/texlive/2024/bin/x86_64-linux:$PATH"
