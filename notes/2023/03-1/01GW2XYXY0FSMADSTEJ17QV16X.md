---
id: 01GW2XYXY0FSMADSTEJ17QV16X
created: 2023-03-21T20:32:24Z
updated: 2023-03-21T22:05:25Z
type: memo
title: Setting up MaaS
imported_from: Obsidian
---
21-03-2023 20:32

Tags: #maas 

# Setting up MaaS

---
Install MaaS
```Bash
sudo snap install maas
```

Update apt
```Bash
sudo apt update -y
```

Install PostgreSQL
```Bash
sudo apt install -y postgresql
```

Install MaaS Test Database
```Bash
sudo snap install maas-test-db
```

Initialize MaaS
```Bash
sudo maas init region+rack --database-uri maas-test-db:///
```

Create user
```Bash
sudo maas createadmin
```

Create an API Key
```Bash
sudo maas apikey --username yourusername
```

Login at URL
http://--ip-addr--:5240/MAAS



---
## References