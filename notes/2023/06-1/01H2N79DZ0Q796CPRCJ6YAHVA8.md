---
id: 01H2N79DZ0Q796CPRCJ6YAHVA8
created: 2023-06-11T12:35:56Z
updated: 2023-06-11T12:44:36Z
type: memo
title: Import kube config
---
11-06-2023 13:36

Tags: 


---
#### This will import the kube config from a new cluster and merge it with the existing config

Copy config from cluster node to local machine
```Bash
scp steve@<node>:~/.kube/config ~/.kube/config.new
```

Create a backup of the existing file
```Bash
cp ~/.kube/config ~/.kube/config.bak
```

merge with existing file into a new file
```Bash
KUBECONFIG=~/.kube/config:~/.kube/config.new kubectl config view --flatten > /tmp/config
```

Overwrite the config with the new file
```Bash
mv /tmp/config ~/.kube/config
```

Remove the backup
```Bash
rm ~/.kube/config.bak
```

---
## References