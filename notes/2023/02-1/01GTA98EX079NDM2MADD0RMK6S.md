---
id: 01GTA98EX079NDM2MADD0RMK6S
created: 2023-02-27T20:33:08Z
updated: 2023-02-28T20:24:34Z
type: memo
title: Setup Rancher
imported_from: Obsidian
---
27-02-2023 20:33

Tags: #rancher

# Setup Rancher

---
Rancher quick start guide - https://www.rancher.com/quick-start

Install Linux
Set IP Config

Install Docker
```Bash
curl https://releases.rancher.com/install-docker/20.10.sh | sh
```

Create the Docker user group if it doesn't already exist
```Bash
sudo groupadd docker
```

Add current user to the group
```Bash
sudo usermod -aG docker $USER
```

Activate changes
```Bash
newgrp docker
```

Install Rancher container
```Bash
sudo docker run --privileged -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher
```

Navigate to https://serverip to complete the install

---
## References