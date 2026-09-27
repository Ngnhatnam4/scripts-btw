!#/bin/bash

if sudo -n true 2</dev/null; then
   echo "ok"
else
   echo "maybe passwordless sudo user or sudo access not avaliable"
fi
# Get BlackArch script
curl -O https://blackarch.org/strap.sh
# Verify SHA1 sum
echo 00688950aaf5e5804d2abebb8d3d3ea1d28525ed strap.sh | sha1sum -c

# Make the script executable
chmod +x strap.sh

# Run the script

sudo ./strap.sh

#now update script

sudo pacman -Syu

echo "finished"
