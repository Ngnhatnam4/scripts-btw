!#/bin/bash
# Check sudo permission
if sudo -n true 2>/dev/null; then 
   echo "ok"
else 
   echo "maybe passwordless sudo user or sudo access not avaliable"
fi
# Get keys 
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
# Install chaotic-keyring and mirrorlist
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'

sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
# Add chaotic-aur pacman repo at /etc/pacman.conf
sudo tee -a /etc/pacman.conf > /dev/null << 'EOF'

[chaotic-aur] 
Include = /etc/pacman.d/chaotic-mirrorlist
EOF

# Update
sudo pacman -Syuu

echo "finished"
