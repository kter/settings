#!/bin/bash

ln -fs .gitignore $HOME/
ln -fs .gvimrc $HOME/
ln -fs .irbrc $HOME/
ln -fs .tmux.conf $HOME/
ln -fs .vimrc $HOME/
ln -fs .vimrc_evervim.sample $HOME/
ln -fs .zsh/ $HOME/
ln -fs .zshrc $HOME/
ln -fs .zshrc.local $HOME/

mkdir -p $HOME/.vim/undo
mkdir -p $HOME/.vim/tmp

