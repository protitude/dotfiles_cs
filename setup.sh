#!/bin/bash
files=( ".tmux-git" ".tmux-git.conf" ".tmux.conf" ".tmux.theme.sh" ".bash_profile" ".ansible.cfg" ".gitconfig" ".gitignore" ".bash_ps1" ".vim" ".vimrc" ".osx" ".tmux.conf" ".goto_shortcuts" ".zsh" ".zshrc")

for i in "${files[@]}"
do
  if [ ! -L $1$i ]
  then
    ln -s $(pwd)"/$i" "$1$i"
    echo "linked $i"
  fi
done

if [ ! -d bundle ]
then
  mkdir .vim/bundle
  git clone https://github.com/VundleVim/Vundle.vim.git .vim/bundle/Vundle.vim
  npm -g install instant-markdown-d
fi

if [ ! -L $1.vim/bundle/vim-multiple-cursors ]
then
  vim +PluginInstall +qall
fi

