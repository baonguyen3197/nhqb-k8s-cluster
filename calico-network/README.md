# First, check nodes status

`kubectl get nodes -o wide`

```
NAME                 STATUS     ROLES           AGE    VERSION   INTERNAL-IP      EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
nhqb-ubuntu-01       NotReady   
```

# Check kubelet status on one of the nodes

`systemctl status kubelet`

```
reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized
```

# Install Calico CNI

`kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.3/manifests/tigera-operator.yaml`
`kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.3/manifests/custom-resources.yaml`

## Port Forward Whisker

`kubectl -n calico-system port-forward svc/whisker 8081:8081 --address 0.0.0.0`
