#!/bin/bash

echo "Starting config..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s $HOME/dotfiles/.tmux.conf $HOME/
echo "Now enter on tmux and use tmux source-file ~/.tmux.conf"
echo "Done!'
