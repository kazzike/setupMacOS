#!/bin/bash

# Variables for paths and passphrase
# The passphrase is used to encrypt the backup of the dotfiles
GPG_PASS="your_secure_passphrase"  # Define your passphrase here and ensure it's secure
DESKTOP_PATH="$HOME/Desktop"

echo "Running initial setup..."

# Disable the dashboard to improve performance
defaults write com.apple.dashboard mcx-disabled -bool true
killall Dock

# Enable the "Show battery percentage in the menu bar" feature for better battery management
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Enable the "Use scroll gesture with the Ctrl key to zoom" feature for easier zooming
defaults write com.apple.universalaccess scrollToZoom -bool true

# Show the full POSIX path in the Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Set the default screenshot format to PNG for better compatibility
defaults write com.apple.screencapture type -string "png"

# Enable tap to click on the trackpad
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Show the user library by default
chflags nohidden ~/Library

# Use list view by default in Finder
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Prevent creation of .DS_Store files on network drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Show the path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show the status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Restart Finder to apply changes
killall Finder

# Enable the Develop menu in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true

# Set an image as the desktop background
osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/path/to/image.jpg"'

# Check and install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew installation completed."
fi

# Backup important files
echo "Creating encrypted backup of important files..."
cd $HOME

# Ensure GnuPG is installed for encryption
if ! command -v gpg &> /dev/null; then
    echo "GnuPG is not installed. Installing..."
    brew install gnupg
    echo "GnuPG installed successfully."
fi

# Specify the files to backup
dotfiles=".zshrc .gitconfig .ssh/*"
backup_file="backup-$(date +%F-%H%M).tar.gz"
encrypted_backup_file="backup-$(date +%F-%H%M).tar.gz.gpg"

# Create a tar.gz file
tar -czf $backup_file $dotfiles

# Encrypt the tar.gz file, remove original if successful
echo $GPG_PASS | gpg --batch --yes --pinentry-mode loopback --passphrase-fd 0 -c --cipher-algo AES256 -o "$DESKTOP_PATH/$encrypted_backup_file" $backup_file && rm $backup_file

if [ $? -eq 0 ]; then
    echo "Backup completed and saved to Desktop."
else
    echo "Error encrypting the backup."
    rm $backup_file
fi

# List of applications to install with Homebrew
apps=(
    "rectangle"
    "vlc"
    "visual-studio-code"
    "sublime-text"
    "sublime-merge"
    "firefox"
    "brave-browser"
    "iterm2"
    "stats"
    "docker"
    "utm"
    "transmission"
    "imageoptim"
    "keepassxc"
    "tree"
    "thefuck"
)

# Install applications with Homebrew
echo "Installing applications..."
for app in "${apps[@]}"; do
    if ! brew list --cask $app &> /dev/null; then
        echo "Installing $app..."
        brew install --cask $app
    else
        echo "$app is already installed."
    fi
done

# Configure Oh My Zsh and plugins
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "Configuring .zshrc with custom settings..."
cat >> ~/.zshrc <<EOL
alias ll='ls -alF'
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
EOL

# Define aliases to add
aliases_to_add=(
"alias ll='ls -alF'"
"alias la='ls -A'"
"alias l='ls -CF'"
)

# Add aliases to .zshrc if not already present
for alias in "${aliases_to_add[@]}"; do
    grep -qF -- "$alias" "$HOME/.zshrc" || echo "$alias" >> "$HOME/.zshrc"
done

echo "Aliases added to .zshrc."

# Check if Fastfetch is installed
if command -v fastfetch >/dev/null 2>&1; then
    echo "Fastfetch is already installed."
else
    echo "Checking and installing necessary dependencies for Fastfetch..."
    dependencies=("git" "make" "gcc")

    # Check and install each dependency
    for dep in "${dependencies[@]}"; do
        if ! command -v $dep >/dev/null 2>&1; then
            echo "$dep is not installed. Installing..."
            brew install $dep
            if ! command -v $dep >/dev/null 2>&1; then
                echo "Error installing $dep. Aborting Fastfetch installation."
                exit 1
            fi
        else
            echo "$dep is already installed."
        fi
    done

    echo "Installing Fastfetch..."
    git clone https://github.com/LinusDierheimer/fastfetch.git
    cd fastfetch
    make
    sudo make install
    cd ..
    echo "Fastfetch installed successfully."
fi

echo "Displaying system information with Fastfetch:"
fastfetch

# ASCII art success message
echo "Installation and configuration complete!"
# ASCII art of a cat winking
cat_wink="

 \o       o/                                                                o         o   
  v\     /v                                                                <|>       <|>  
   <\   />                                                                 / \       / \  
     \o/    o__ __o     o       o       \o__ __o     o__ __o        __o__  \o/  o/   \o/  
      |    /v     v\   <|>     <|>       |     |>   /v     v\      />  \    |  /v     |   
     / \  />       <\  < >     < >      / \   < >  />       <\   o/        / \/>     < >  
     \o/  \         /   |       |       \o/        \         /  <|         \o/\o          
      |    o       o    o       o        |          o       o    \\         |  v\     o   
     / \   <\__ __/>    <\__ __/>       / \         <\__ __/>     _\o__</  / \  <\  _<|>_ 
                                                                                          
                                                                                          
"

# Print the ASCII art of the cat winking
echo -e "$cat_wink"

# Ask the user if they want to reload the terminal configuration now
echo "Would you like to reload the terminal configuration now? (y/n)"
read response

# Check the user's response
if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "Reloading terminal configuration..."
    exec zsh
else
    echo "Terminal configuration not reloaded. You can do this manually by executing 'exec zsh'."
fi
