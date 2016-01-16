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

mkdir -p $HOME/.vim/undo
mkdir -p $HOME/.vim/tmp

curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
curl -fLo ~/.zplug/zplug --create-dirs https://git.io/zplug
