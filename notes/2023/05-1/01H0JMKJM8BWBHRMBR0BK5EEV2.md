---
id: 01H0JMKJM8BWBHRMBR0BK5EEV2
created: 2023-05-16T15:59:33Z
updated: 2023-05-18T21:11:29Z
type: memo
title: Basic Docker Commands
---
16-05-2023 16:59

Tags: #docker 


---
Create a container and run it in interactive mode, e.g.
```Bash
docker run -it -v ~/code:/code --name Ansible stevevine/ansible:2.14.5-amd64
```
-it   Interactive
--name   Name of the new container
-v   specify a volume

To specify a -v for Windows
```Bash
docker run -it -v C:\Users\Mail\Code:/code --name Ansible stevevine/ansible:2.14.5-amd64   
```

Start a container, e.g.
```Bash
Docker start -i Ansible
```



---
## References