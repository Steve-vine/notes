---
id: 01GSDS6AV8ZESXRKP98MBNNQP9
created: 2023-02-16T18:53:37Z
updated: 2023-03-28T15:05:11Z
type: memo
title: Amend Ubuntu Network Settings
---
15-02-2023 14:23

Tags: #linux #ubuntu #ip

# Amend Ubuntu Network Settings

---
Navigate to
```Bash
cd /etc/netplan
```

Edit the config file.

Example
```Bash
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: false
      dhcp6: false
      addresses:
        - '192.168.1.11/24'
      routes:
        - to: default
          via: 192.168.1.254
      nameservers:
        addresses: [192.168.1.254, 8.8.8.8]
      optional: true
```

---
## References