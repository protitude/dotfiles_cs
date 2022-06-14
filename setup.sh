#!/bin/bash
sudo apt install vim nodejs npm tmux -y
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
wget -P /tmp https://starship.rs/install.sh
chmod u+x /tmp/install.sh
/tmp/install.sh -y

files=( ".tmux-git" ".tmux-git.conf" ".tmux.conf" ".tmux.theme.sh" ".bash_profile" ".gitconfig" ".gitignore" ".vim" ".vimrc" ".tmux.conf" ".goto_shortcuts" )

for i in "${files[@]}"
do
  if [ ! -L ~/$i ]
  then
    mv ~/$i /tmp/
  fi
  ln -s /workspaces/.codespaces/.persistedshare/dotfiles/$i ~/$i
  echo "linked $i"
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

