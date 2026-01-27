#!/bin/bash
set -e

echo "==========================================="
echo "Starting GitOps Setup"
echo "==========================================="

# Verify Docker is working
echo "Verifying Docker..."
docker ps >/dev/null 2>&1 || { echo "Docker is still not accessible. Please run './check-docker.sh' first."; exit 1; }
echo "Docker is working correctly."

# Install Argo CD CLI
echo "Installing Argo CD CLI..."
curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x argocd
sudo mv argocd /usr/local/bin/

# Install Argo CD into the cluster
echo "Installing Argo CD into the Kubernetes cluster..."
kubectl create namespace argocd || echo "Namespace 'argocd' already exists."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
echo "Argo CD installation initiated."

# Wait for each ArgoCD component
echo "Waiting for ArgoCD server..."
kubectl wait --for=condition=Available --namespace argocd deployment/argocd-server --timeout=300s

echo "Waiting for ArgoCD repo server..."
kubectl wait --for=condition=Available --namespace argocd deployment/argocd-repo-server --timeout=300s

echo "Waiting for ArgoCD redis..."
kubectl wait --for=condition=Available --namespace argocd deployment/argocd-redis --timeout=300s

echo "Waiting for ArgoCD applicationset controller..."
kubectl wait --for=condition=Available --namespace argocd deployment/argocd-applicationset-controller --timeout=300s || true

# Extra wait for initialization
echo "Waiting for ArgoCD to fully initialize..."
sleep 20

# Get initial admin password
echo "Retrieving initial Argo CD admin password..."
while ! kubectl -n argocd get secret argocd-initial-admin-secret &>/dev/null; do
  echo "Waiting for admin secret to be created..."
  sleep 5
done

# Store password in a file for easy access
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > "$HOME/argocd-password.txt"

echo ""
echo "==========================================="
echo "Setup Complete!"
echo "==========================================="
echo ""
echo "ArgoCD Admin Password has been saved to: ~/argocd-password.txt"
echo "To view the password, run: cat ~/argocd-password.txt"
echo ""
echo "To access ArgoCD UI:"
echo "1. Run: kubectl port-forward svc/argocd-server -n argocd 8081:443 &"
echo "2. Access: https://localhost:8081"
echo "3. Username: admin"
echo "4. Password: See ~/argocd-password.txt"
echo ""
echo "Current ArgoCD pods status:"
kubectl get pods -n argocd