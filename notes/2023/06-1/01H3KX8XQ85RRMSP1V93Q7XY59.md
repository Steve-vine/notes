---
id: 01H3KX8XQ85RRMSP1V93Q7XY59
created: 2023-06-23T10:37:21Z
updated: 2023-06-23T10:37:22Z
type: memo
title: Give Current User Permissions for Docker in Linux
imported_from: Obsidian
---
23-06-2023 11:35

Tags: #docker #lunix 


---
Create the group id it doesn't exist
```Bash
sudo groupadd docker
```

Add current user to the group
```Bash
sudo usermod -aG docker ${USER}
```

Then log out and back in again


---
## References