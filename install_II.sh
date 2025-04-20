#!/bin/bash
# Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y
# Install necessary packages
echo "Installing necessary packages..."
sudo apt install -y apt-transport-https ca-certificates software-properties-common wget
# Install RetroArch
echo "Installing RetroArch..."
sudo apt install -y retroarch
# If retroarch is not available, use the libretro stable PPA
if ! command -v retroarch &> /dev/null; then
    echo "RetroArch not found, using libretro stable PPA..."
    sudo add-apt-repository -y ppa:libretro/stable
    sudo apt update
    sudo apt install -y retroarch
fi
# Install Plex Media Server
echo "Installing Plex Media Server..."
regex='"build":"linux-x86_64","distro":"debian","url":"(https:\/\/downloads\.plex\.tv\/plex-media-server-new\/[^/]*\/debian\/[^/]*_amd64\.deb)",' 
response=$(curl -s https://plex.tv/api/downloads/5.json) 
[[ $response =~ $regex ]] && downloadURL="${BASH_REMATCH[1]}"
wget -O ./plexmediaserver.deb $downloadURL
sudo dpkg -i ./plexmediaserver.deb
sudo systemctl enable plexmediaserver.service
# Start the services
echo "Starting RetroArch and Plex Media Server services..."
# RetroArch is not a service, it's a user application
sudo systemctl start plexmediaserver.service
# Install Kodi
echo "Installing Kodi..."
sudo apt install -y kodi
# Configure Kodi
echo "Configuring Kodi..."
# Create a directory for Kodi's configuration
mkdir -p ~/.kodi/userdata
# Enable the PVR IPTV Simple Client add-on
echo "Enabling PVR IPTV Simple Client add-on..."
kodi-send --action="EnableAddon(pvr.iptvsimple)"
# Install additional entertainment applications
echo "Installing additional entertainment applications..."
sudo apt install -y strawberry lollypop smplayer audacious vlc
# Final message
echo "Installation and setup complete. Please configure RetroArch, Plex Media Server, Kodi, and other applications as needed."
