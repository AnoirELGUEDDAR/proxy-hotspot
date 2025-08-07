#!/bin/bash

echo "================ PROXY HOTSPOT INSTALLER ================"
echo "Current time: $(date)"
echo "User: $USER"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo"
    exit 1
fi

# Install required packages
echo "Installing required packages..."
apt-get update
apt-get install -y redsocks network-manager iptables-persistent curl netcat-openbsd

# Check if redsocks installed correctly
if ! command -v redsocks &> /dev/null; then
    echo "❌ Failed to install redsocks! Please install it manually."
    exit 1
fi

# Create config directory if it doesn't exist
if [ ! -d "config" ]; then
    mkdir -p config
fi

# Create config file if it doesn't exist
if [ ! -f "config/config.sh" ]; then
    echo "Creating configuration file..."
    if [ -f "config/config.template.sh" ]; then
        cp config/config.template.sh config/config.sh
        echo "Please edit config/config.sh with your proxy details"
    else
        echo "❌ Configuration template not found! Please create config/config.sh manually."
    fi
fi

# Make scripts executable
echo "Making scripts executable..."
chmod +x scripts/*.sh

echo -e "\n================ INSTALLATION COMPLETE =================="
echo "Next steps:"
echo "1. Edit config/config.sh with your proxy details"
echo "2. Run scripts/setup_proxy.sh to start your proxy hotspot"
echo "3. To auto-start on boot, run scripts/create_autostart.sh"