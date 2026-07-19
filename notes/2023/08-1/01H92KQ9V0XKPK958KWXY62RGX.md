---
id: 01H92KQ9V0XKPK958KWXY62RGX
created: 2023-08-30T06:57:32Z
updated: 2023-08-30T06:57:32Z
type: memo
title: Install kubectl
imported_from: Obsidian
---
30-08-2023 07:56

Tags: #kubectl #kubernetes  


---
Download the latest version
```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

Install
```
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

---
## References