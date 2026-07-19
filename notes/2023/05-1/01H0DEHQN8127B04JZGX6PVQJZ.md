---
id: 01H0DEHQN8127B04JZGX6PVQJZ
created: 2023-05-14T15:37:29Z
updated: 2025-06-08T17:25:21.871999Z
type: memo
title: Install k3s
---
14-05-2023 16:37

Tags: #k3s 


---
Install k3s, dependancies and additional tools on first server

Install as server with agent functionality
```Bash
curl -sfL https://get.k3s.io | sh -
```

Install k3s and disable loadbalancer service and Traefik, and specify DNS name for SAN Certificate.
```
curl -sfL https://get.k3s.io | sh -s server \
  --cluster-init \
  --disable=servicelb \
  --disable=traefik \
  --tls-san vm-crossplane.citops.net
```

Check it's working
```
sudo k3s kubectl get node
```

Get the context to use locally
```
sudo cp /etc/rancher/k3s/k3s.yaml ~
sudo chown -R <username> k3s.yaml
export KUBECONFIG=~/k3s.yaml
```
Kubectl should now work

### Install MetalLB

Get the helm chart
```
helm repo add metallb https://metallb.github.io/metallb
helm repo update
```

Install MetalLB
```
helm install metallb metallb/metallb --namespace metallb-system --create-namespace
```

Create a Layer2 Advertisement
```
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
	name: l2adv
	namespace: kube-system
```

Create an address pool
```
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
	name: addr-pool
	namespace: kube-system
spec:
	addresses:
	- 192.168.10.110-192.168.10.120
```

---
## References