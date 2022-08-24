#!/bin/bash
if [[ $1 == "linode" ]]; then
  type = 'linode'
else
  type = 'cs'
fi
sudo apt update
sudo apt install python3-dev python3-pip python3-setuptools -y
sudo apt install vim nodejs npm tmux -y
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
if [[ $type == 'cs' ]]; then
  wget -P /tmp https://starship.rs/install.sh
  chmod u+x /tmp/install.sh
  /tmp/install.sh -y
fi
pip3 install thefuck --user

files=( ".tmux-git" ".tmux-git.conf" ".tmux.conf" ".tmux.theme.sh" ".bash_profile" ".gitconfig" ".gitignore" ".vim" ".vimrc" ".tmux.conf" ".goto_shortcuts" ".zshrc" )

for i in "${files[@]}"
do
  if [ ! -L ~/$i ]
  then
    mv ~/$i /tmp/
  fi
  if [[ $type == 'cs' ]]; then
    ln -s "/workspaces/.codespaces/.persistedshare/dotfiles/$i" ~/$i
  else
    ln -s "/home/protitude/dotfiles/$i" ~/$i
  fi
  echo "linked $i"
done

if [ ! -d bundle ]
then
  mkdir .vim/bundle
  git clone https://github.com/VundleVim/Vundle.vim.git .vim/bundle/Vundle.vim
fi

if [ ! -L $1.vim/bundle/vim-multiple-cursors ]
then
  vim +PluginInstall +qall
fi
