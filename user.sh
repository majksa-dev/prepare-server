#!/bin/bash

# Install Oh My ZSH
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install PowerLevel10k
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

# Setup .dotfiles
git clone https://github.com/majksa-dev/dotfiles.git .dotfiles
cd .dotfiles
stow --adopt .
git restore .
cd -
