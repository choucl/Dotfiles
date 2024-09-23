# Dotfiles

This is the repository that stores all my useful dotfiles in Linux.

## Usage

1. Clone the repo to the home directory

   `git clone https://github.com/choucl/Dotfiles.git ~`

2. Use GNU `stow` to manage which configuration to use

   `stow [config]`

   Or use wildcard to select all

   `stow */`

## Neovim

Neovim v0.10
```bash
git checkout release-0.10
make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=$HOME/.local
make install
```

### Astronvim dependencies
1. [ripgrep](https://github.com/BurntSushi/ripgrep)
```bash
sudo apt update -y
sudo apt install -y ripgrep
```

2. [lazygit](https://github.com/jesseduffield/lazygit)
```bash
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
```

3. [bottom](https://github.com/ClementTsang/bottom)
```bash
curl -LO https://github.com/ClementTsang/bottom/releases/download/0.10.2/bottom_0.10.2-1_amd64.deb
sudo dpkg -i bottom_0.10.2-1_amd64.deb
```

## Zsh

Install the following dependancies:

1. [zap](https://github.com/zap-zsh/zap)
```bash
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 --keep
```

2. [zoxide](https://github.com/ajeetdsouza/zoxide)
```bash
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
```

3. [nvm](https://github.com/nvm-sh/nvm)
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
nvm install 18
```

4. [fzf](https://github.com/junegunn/fzf)
```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

5. [bat](https://github.com/sharkdp/bat)'
```bash
sudo apt install bat
ln -s /usr/bin/batcat ~/.local/bin/bat
```
