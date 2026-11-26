#!/bin/bash
if [[ $1 == "linode" ]]; then
  type='linode'
elif [[ $1 == "pi" ]]; then
  type='pi'
else
  type='cs'
fi

NVIM_VERSION="v0.12.6"

install_nvim() {
  case "$(uname -m)" in
    x86_64) arch='x86_64' ;;
    aarch64|arm64) arch='arm64' ;;
    *) echo "skipping neovim install: unsupported arch $(uname -m)"; return ;;
  esac
  if command -v nvim >/dev/null && nvim --version | head -1 | grep -q "${NVIM_VERSION}"; then
    echo "neovim ${NVIM_VERSION} already installed"
    return
  fi
  local tarball="nvim-linux-${arch}.tar.gz"
  curl -fsSL -o "/tmp/${tarball}" \
    "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${tarball}"
  rm -rf "$HOME/.local/nvim-linux-${arch}"
  mkdir -p "$HOME/.local/bin"
  tar -C "$HOME/.local" -xzf "/tmp/${tarball}"
  ln -sf "$HOME/.local/nvim-linux-${arch}/bin/nvim" "$HOME/.local/bin/nvim"
  rm -f "/tmp/${tarball}"
  echo "installed neovim ${NVIM_VERSION}"
}

if [[ $type == 'cs' ]]; then
  sudo apt update
  sudo apt install python3-dev python3-pip python3-setuptools -y
  sudo apt install nodejs npm tmux ripgrep build-essential unzip curl -y
  ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
  git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
  wget -P /tmp https://starship.rs/install.sh
  chmod u+x /tmp/install.sh
  /tmp/install.sh -y
fi

install_nvim
export PATH="$HOME/.local/bin:$PATH"

files=( ".tmux-git" ".tmux-git.conf" ".tmux.conf" ".tmux.theme.sh" ".bash_profile" ".gitconfig" ".gitignore" ".goto_shortcuts" ".zshrc" ".config/nvim" )

mkdir -p ~/.config
for i in "${files[@]}"
do
  if [ -e ~/$i ] && [ ! -L ~/$i ]
  then
    mv ~/$i /tmp/
  fi
  if [[ $type == 'cs' ]]; then
    ln -sfn "/workspaces/.codespaces/.persistedshare/dotfiles/$i" ~/$i
  elif [[ $type == 'pi' ]]; then
    ln -sfn "/home/pi/dotfiles/$i" ~/$i
  else
    ln -sfn "/home/protitude/dotfiles/$i" ~/$i
  fi
  echo "linked $i"
done

# Install plugins at the versions pinned in lazy-lock.json
if command -v nvim >/dev/null; then
  nvim --headless "+Lazy! restore" +qa
  # mason-lspconfig skips ensure_installed in headless mode, so install explicitly
  nvim --headless "+MasonInstall typescript-language-server rust-analyzer intelephense" +qa
fi

if [[ $type == 'linode' ]]; then
  if test -f "linode-setup.sh"; then
    ./linode-setup.sh
  fi
fi
