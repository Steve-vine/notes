---
id: 01GTMMAPH0JWZG86M5663NHF8M
created: 2023-03-03T20:59:00Z
updated: 2023-05-22T12:23:16Z
type: memo
title: Setup a Second Linux Box to Access the Cluster
---
cd .03-03-2023 17:38

Tags: #talos #cubectl 

# Setup a Second Linux Box to Access the Cluster

---
On the box that can already access the cluster copy the config file from:
```Bash
~/.talos
```
To the new box in the same folder

Then run 
```Bash
talosctl -n <IP> kubeconfig
```

kubectl should now see the cluster
```Bash
kubectl cluster-info
```

---
## References