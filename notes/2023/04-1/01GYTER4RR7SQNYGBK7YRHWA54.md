---
id: 01GYTER4RR7SQNYGBK7YRHWA54
created: 2023-04-24T20:19:43Z
updated: 2023-04-24T20:22:27Z
type: memo
title: Control a remote docker host
imported_from: Obsidian
---
24-04-2023 21:19

Tags: #docker 


---
Set the Docker host env variable to the host

Windows
```Powershell
$env:DOCKER_HOST="ssh://steve@vm-docker-1"  
```

Linux
```Bash
export DOCKER_HOST="ssh://steve@vm-docker-1" 
```

Then run docker commands as normal

---
## References