#!/bin/bash

# Configure locale
sudo update-locale LANG=en_US.UTF-8

# Install from apt
sudo apt-get update
sudo apt-get install -y curl zsh git ssh ruby-full zoxide stow ca-certificates build-essential

# Install docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Setup docker
sudo groupadd docker

# Setup ssh
sudo groupadd ssh
sed -i "s/.*PasswordAuthentication .*//g" /etc/ssh/sshd_config
sed -i "s/.*PermitRootLogin .*//g" /etc/ssh/sshd_config
printf "#Custom config\nPasswordAuthentication no\nPermitRootLogin no\nAllowGroups ssh\n" | sudo tee /etc/ssh/sshd_config
sudo systemctl restart sshd

# Setup my user
MY_PASSWORD=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13; printf)
MY_USER=majksa
MY_HOME=/home/$MY_USER
sudo useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' "$MY_PASSWORD") -G sudo,docker,ssh -s /usr/bin/zsh $MY_USER

sudo mkdir -p $MY_HOME/.ssh
sudo chmod 700 $MY_HOME/.ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7Tms79s5lHTczS+7EDwe+UoRxb+RilvXPTAtpqr/DB majksa@Ondra" | sudo tee $MY_HOME/.ssh/authorized_keys > /dev/null
sudo chown -R $MY_USER:$MY_USER $MY_HOME/.ssh
sudo chmod 600 $MY_HOME/.ssh/authorized_keys

# Install Oh My ZSH
sudo -u $MY_USER sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install PowerLevel10k
OMZSH_CUSTOM=$MY_HOME/.oh-my-zsh/customer
git clone https://github.com/romkatv/powerlevel10k.git $OMZSH_CUSTOM/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $OMZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $OMZSH_CUSTOM/plugins/zsh-autosuggestions

# Setup .dotfiles
git clone https://github.com/majksa-dev/dotfiles.git $MY_HOME/.dotfiles
stow $MY_HOME/.dotfiles

# Install colorls
sudo gem install colorls

# Summary
echo
echo
echo "Successfully finished setup!"
echo "Here is your password: '$MY_PASSWORD'"

