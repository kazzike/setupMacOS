# macOS Setup Script

This script is designed to automate the setup and configuration of a macOS system, ensuring that all essential tools and settings are optimally configured from the start. It handles system preferences, installs commonly used applications, and sets up security measures like encrypted backups.

## Features

- **System Preferences**: Optimizes various macOS settings for performance and usability.
- **Application Installation**: Automatically installs a wide range of useful software through Homebrew.
- **Security Enhancements**: Secures your configuration files with encrypted backups.
- **Custom Terminal Setup**: Installs and configures Oh My Zsh, plugins, and themes, enhancing the terminal experience.

## Prerequisites

Before running the script, ensure the following:
- You have administrative access on your macOS device.
- Your machine is connected to the Internet.

## Installation

To install and run the setup script, follow these steps:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/kazzike/setupMacOS
   cd setupMacOS

2. **Make the Script Executable**:

chmod +x setup_MacOS.sh

3. **Run the Script**:

./setup_MacOS.sh

**NOTE**: If permissions issues arise, run the script with sudo:

sudo ./setup_script.sh

## Detailed Script Actions
- Disables Dashboard: Improves system performance by turning off the Dashboard.
- Shows Battery Percentage: Enhances monitoring by displaying battery life percentage.
- Enables Scroll-to-Zoom: Facilitates zooming on the desktop using scroll gestures.
- Configures Finder: Sets Finder to show full POSIX path, list view by default, and more.
- Installs Applications: A set list from Homebrew, including browsers, media players, and development tools.
- Encrypts and Backups: Safeguards critical configuration files through GPG encryption.
- Terminal Enhancements: Sets up a robust terminal environment with customized settings.
- Customization

Modify the apps array within the script to change which applications are installed, or adjust any system configuration command to suit your personal preferences.

## ASCII Art Success Message
Upon successful completion, the script will display a fun ASCII art message:

## Contributing
Contributions to improve the script or add functionalities are welcome. Please fork the repository, make your changes, and submit a pull request.