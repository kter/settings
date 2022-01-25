#!/bin/bash

#abspath="$(cd $(dirname $file) && pwd)/$(basename $file)"
file=`echo $0`

ln -fs $(dirname $file)/.gitignore $HOME/
ln -fs $(dirname $file)/.gvimrc $HOME/
ln -fs $(dirname $file)/.irbrc $HOME/
ln -fs $(dirname $file)/.tmux.conf $HOME/
ln -fs $(dirname $file)/.vimrc $HOME/
ln -fs $(dirname $file)/.vimrc_evervim.sample $HOME/
ln -fs $(dirname $file)/.zsh/ $HOME/
ln -fs $(dirname $file)/.zshrc $HOME/
ln -fs $(dirname $file)/.zshrc.local $HOME/
ln -fs $(dirname $file)/.vim $HOME/

mkdir -p $HOME/.vim/undo
mkdir -p $HOME/.vim/tmp

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
curl -sL zplug.sh/installer | zsh

git config --global pager.log 'diff-highlight | less'
git config --global pager.show 'diff-highlight | less'
git config --global pager.diff 'diff-highlight | less'
git config --global diff.compactionHeuristic true
