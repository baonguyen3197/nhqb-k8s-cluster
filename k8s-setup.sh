#!/usr/bin/env bash
set -euo pipefail

K8S_VERSION="v1.34"
KEYRING_DIR="/etc/apt/keyrings"
K8S_KEYRING="${KEYRING_DIR}/kubernetes-apt-keyring.gpg"
K8S_REPO_FILE="/etc/apt/sources.list.d/kubernetes.list"

echo "[INFO] Updating apt package index..."
sudo apt-get update -y

echo "[INFO] Installing required packages..."
sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \ư
  gpg

echo "[INFO] Ensuring ${KEYRING_DIR} exists..."
sudo mkdir -p -m 755 "${KEYRING_DIR}"

# ------------------------------------------------------------
# Download the public signing key for the Kubernetes package repositories
# ------------------------------------------------------------
if [[ -f "${K8S_KEYRING}" ]]; then
  echo "[INFO] Existing Kubernetes GPG key found, overwriting..."
  sudo rm -f "${K8S_KEYRING}"
fi

echo "[INFO] Downloading Kubernetes ${K8S_VERSION} signing key..."
curl -fsSL "https://pkgs.k8s.io/core:/stable:/${K8S_VERSION}/deb/Release.key" \
  | sudo gpg --dearmor --yes -o "${K8S_KEYRING}"

echo "[INFO] Setting permissions on keyring..."
sudo chmod 644 "${K8S_KEYRING}"

# ------------------------------------------------------------
# Add the Kubernetes apt repository
# ------------------------------------------------------------
echo "[INFO] Writing Kubernetes APT repository..."
echo "deb [signed-by=${K8S_KEYRING}] https://pkgs.k8s.io/core:/stable:/${K8S_VERSION}/deb/ /" \
  | sudo tee "${K8S_REPO_FILE}" > /dev/null

sudo chmod 644 "${K8S_REPO_FILE}"

echo "[INFO] Updating apt package index with Kubernetes repo..."
sudo apt-get update -y

echo "[INFO] Installing kubelet, kubeadm, kubectl..."
sudo apt-get install -y kubelet kubeadm kubectl

echo "[INFO] Holding Kubernetes packages at current version..."
sudo apt-mark hold kubelet kubeadm kubectl

echo "[INFO] Enabling kubelet service..."
sudo systemctl enable --now kubelet

echo "[SUCCESS] Kubernetes ${K8S_VERSION} APT setup completed."
