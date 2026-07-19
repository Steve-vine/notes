---
id: 01JWKDSSBVSKCRFZ7G9W54H9AT
created: 2025-05-31T15:01:40.347Z
updated: 2025-05-31T15:11:31.108Z
type: memo
title: k3sup
---
31-05-2025 16:01

Tags: #k3s #kubernetes  


---
### Installing k3sup

Download the Go script and move it to the scripts folder
```
sudo curl -sLS https://get.k3sup.dev | sudo sh
mv k3sup-darwin-arm64 ~/code/scripts/k3s
```
### Setup a K3s Cluster

Set env variable for the cluster IP
```
export IP=<ip-address>
```

Install the cluster
```
k3sup install --ip $IP --user <username> \
--merge \
--local-path $HOME/.kube/config \
--context <context-name>
```

Install the cluster with the k3s load balancer disabled
```
k3sup install --ip $IP --user <username> \
--merge \
--local-path $HOME/.kube/config \
--context <context-name> \
--k3s-extra-args "--disable servicelb"
```

---
## References