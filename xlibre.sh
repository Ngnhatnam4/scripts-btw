#!/bin/bash 

# Check sudo permission
if sudo -n true 2>/dev/null; then 
   echo "ok"
else 
   echo "maybe passwordless sudo user or sudo access not avaliable"
fi
# Fetching XLibre Arch Linux keys 
curl -O https://xlibre-arch.github.io/xlibre-archlinux.asc
sudo pacman-key --add xlibre-archlinux.asc
sudo pacman-key --finger B97F7C613F359424
sudo pacman-key --lsign-key B97F7C613F359424
# Add xlibre-stable repos
sudo tee -a /etc/pacman.conf > /dev/null << 'EOF'

[xlibre-stable]
Server = https://packages.xlibre.net/arch/stable/$arch
EOF
# Update database
sudo pacman -Syu
echo "finished"
