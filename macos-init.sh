# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install oh-my-zsh
brew install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Create work directory
mkdir -p ~/code

# Install sourcetree
brew cask install sourcetree

# Install wget
brew install wget

# Get Miniconda 
wget -c https://repo.anaconda.com/archive/Anaconda3-2019.07-MacOSX-x86_64.sh

# Install nodejs
brew install nvm 
mkdir ~/.nvm
echo "export NVM_DIR=~/.nvm" >> ~/.zshrc
cat << EOT >> ~/.zshrc
# NVM Constants
export NVM_DIR="$HOME/.nvm"
 [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
 [ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion
EOT
nvm install --lts
nvm use default

# Install Docker
brew cask install docker

# Install VSCode
brew cask install visual-studio-code

# Install python3
brew install python3

# Generate ssh keys
if [ ! -f ~/.ssh/id_rsa ]; 
	then ssh-keygen -t rsa ; 
fi

# Install Discordapp
brew tap caskroom/cask
brew cask install slack
brew cask install postman
