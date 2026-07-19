---
id: 01GSCZZY58EYJBJBCCEA3AA49D
created: 2023-02-16T11:33:13Z
updated: 2023-02-16T11:33:13Z
type: memo
title: Setting up Talos in Docker
---
16-02-2023 10:45

Tags: 

# Setting up Talos in Docker

---
This must be installed on a box with Docker running
e.g. Windows machine with Docker Desktop and WSL (Ubuntu) - install in the WSL instance.

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

Create a cluster
```Bash
talosctl cluster create
```

Check the Nodes
```Bash
$ kubectl get nodes -o wide
```

View the Deashboard
```Bash
talosctl dashboard --nodes 10.5.0.2
```

Destryoy the cluster
```Bash
talosctl cluster destroy
```


---
## References