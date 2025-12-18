# Turn swap off
sudo swapoff -a # Disable swap immediately - Temporary
sudo sed -i '/^[^#].*\s\+swap\s\+/ s/^/#/' /etc/fstab # Disable swap permanently
sudo sed -i.bak '/^#.*swap/s/^#//' /etc/fstab

