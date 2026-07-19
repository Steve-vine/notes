---
id: 01GSDS6AV845E1FQART7SB3WD2
created: 2023-02-16T18:53:37Z
updated: 2023-03-20T17:01:18Z
type: memo
title: Setup Talos on Bare Metal
---
16-02-2023 11:34

Tags: 

# Setup Talos on Bare Metal

---
This is installed on multiple machines

### Setup Management Environment
Download talosctl
```Bash
curl -sL https://talos.dev/install | sh
```

Download and install kubectl
```Bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

```Bash
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

Download the latest ISO image
https://github.com/siderolabs/talos/releases
**talos-amd64.iso** or **talos-arm64.iso** for bare metal

Decide which IP Addresses to use for each note in the cluster.
e.g.
https://192.168.1.11:6443 - Control Plane
https://192.168.1.12:6443 - Worker Node
etc...

Boot the first machine up with the ISO image and check the IP address 
![[Pasted image 20230216121124.png]]

Setup the first node using interactive mode
```Bash
talosctl apply-config --insecure --mode=interactive --nodes 192.168.1.81
```

Setup additional nodes using interactive mode based on the configuration of the first node
```Bash
talosctl apply-config --insecure --mode=interactive --nodes 192.168.1.82 -e 192.168.1.81
```

Wait for all services to be running on the node you are setting up
```Bashtalosctl services -n 192.168.1.81
talosctl services -n 192.168.1.81
```

Download the config (only required once, not each node)
```Bash
talosctl kubeconfig -n 192.168.1.81
```

Check the Nodes
```Bash
kubectl get nodes -o wide
```

View the Deashboard
```Bash
talosctl dashboard --nodes 10.5.0.2
```


Apply the config using the machines IP Address
```Bash
talosctl apply-config --insecure --nodes 192.168.0.2 --file controlplane.yaml
```




---
## References