#!/bin/sh
# main zsh source file
export ZDOTDIR=$HOME/.config/zsh

source "$ZDOTDIR/aliases"
source "$ZDOTDIR/exports"
source "$ZDOTDIR/plugins"

# some useful options (man zshoptions)
setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
stty stop undef		# Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')

# beeping is annoying
unsetopt BEEP

# Colors
autoload -Uz colors && colors

# TODO Remove these
setxkbmap -option caps:escape
xset r rate 210 40

# Speedy keys
# xset r rate 210 40

# Environment variables set everywhere
export EDITOR="nvim"
export TERMINAL="gnome-terminal"
export BROWSER="brave"

# For QT Themes
export QT_QPA_PLATFORMTHEME=qt5ct

# remap caps to escape
# setxkbmap -option caps:escape
# swap escape and caps
# setxkbmap -option caps:swapescape

# history
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt appendhistory
setopt INC_APPEND_HISTORY  # apends every comman dto the hisotry file one it is executed
setopt SHARE_HISTORY  # reloads teh history whenever you use it
setopt HIST_FIND_NO_DUPS
