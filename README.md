# This is the installation guide for MyK8sProject

## Prerequisites

> 3 VMs Ubuntu 24.04 LTS or later
> Kubernetes cluster (version 1.34 or later)

---

# Post-Installation Steps

## Docker Installation

### Installation Steps

`chmod +x k8s-setup.sh`

`./k8s-setup.sh`

## If facing lock issues

### Kill any apt processes

`sudo killall apt apt-get`

### Remove locks

`sudo rm /var/lib/apt/lists/lock`

`sudo rm /var/cache/apt/archives/lock`

`sudo rm /var/lib/dpkg/lock*`

### Reconfigure and update

`sudo dpkg --configure -a`

`sudo apt update`

---

# Troubleshooting K8s Issues

## Troubleshoot K8s network issues using

`kubectl get nodes -o wide`

```
E1220 14:06:59.006364    4763 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"https://192.168.81.141:6443/api?timeout=32s\": dial tcp 192.168.81.141:6443: connect: no route to host"
E1220 14:07:02.077253    4763 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"https://192.168.81.141:6443/api?timeout=32s\": dial tcp 192.168.81.141:6443: connect: no route to host
```

### Check the kubelet service status on the node

`systemctl status kubelet`

Root cause might be that the node is not able to reach the control plane due to network issues.

## Fix (step-by-step):

### 1. Check IP server that kubectl is using

`kubectl config view --minify | grep server`

### 2. Edit kubeconfig

`sudo nano ~/.kube/config`

### 3. Update the server IP to the correct control plane IP address

```
sudo nano /etc/kubernetes/manifests/kube-apiserver.yaml
```

> ###### update the --advertise-address and --bind-address flags if necessary

### 4. If the issue persists, check the admin.conf file for correct server IP

`sudo nano /etc/kubernetes/admin.conf`

### 5. Restart kubelet service

`sudo systemctl restart kubelet`
