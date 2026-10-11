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
# Detect display manager (lightdm or sddm)
DM=""
DM_WAS_ENABLED=false

# Prefer the one that is enabled as a systemd service
for candidate in lightdm sddm; do
    if systemctl is-enabled "$candidate.service" &>/dev/null; then
        DM="$candidate"
        DM_WAS_ENABLED=true
        break
    fi
done

# Otherwise fall back to whichever is installed but not enabled
if [ -z "$DM" ]; then
    for candidate in lightdm sddm; do
        if pacman -Qq "$candidate" &>/dev/null; then
            DM="$candidate"
            break
        fi
    done
fi

if [ -n "$DM" ]; then
    if [ "$DM_WAS_ENABLED" = true ]; then
        echo "Detected enabled display manager: $DM"
        echo "Disabling $DM before replacing Xorg..."
        sudo systemctl disable "$DM.service"
    else
        echo "Detected display manager installed but not enabled: $DM"
    fi

    # Replace Xorg with XLibre (--ask=4 auto-accepts removing the conflicting Xorg packages)
    echo "Replacing Xorg with XLibre..."
    sudo pacman -S --needed --noconfirm --ask=4 xlibre-xserver xlibre-input-libinput

    # Enable the display manager (re-enable if it was enabled, otherwise just enable)
    echo "Enabling $DM..."
    sudo systemctl enable "$DM.service"

    echo "Reboot to start $DM with XLibre."
else
    echo "No LightDM or SDDM detected, skipping display manager setup"
fi
esac 

echo "finished"
