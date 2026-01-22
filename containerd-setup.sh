# Turn swap off
sudo swapoff -a # Disable swap immediately - Temporary
sudo sed -i '/^[^#].*\s\+swap\s\+/ s/^/#/' /etc/fstab # Disable swap permanently
# sudo sed -i.bak '/^#.*swap/s/^#//' /etc/fstab

# Configure containerd
sudo rm -f /etc/containerd/config.toml
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

# Restart containerd
sudo systemctl restart containerd
sudo systemctl enable containerd
sudo systemctl status containerd --no-pager
sudo systemctl daemon-reload

# Load necessary kernel modules
sudo modprobe overlay
sudo modprobe br_netfilter

# Set up required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system