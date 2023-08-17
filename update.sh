#!/bin/bash

echo "Updating system packages..."

# Update the list of available packages
sudo apt-get update

# Upgrade the current packages
sudo apt-get upgrade -y

# Perform distribution upgrade
sudo apt-get dist-upgrade -y

# Clean up any unused packages
sudo apt-get autoremove -y

# Clean up the local repository
sudo apt-get autoclean -y

echo "System update completed successfully."