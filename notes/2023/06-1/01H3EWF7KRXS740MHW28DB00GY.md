---
id: 01H3EWF7KRXS740MHW28DB00GY
created: 2023-06-21T11:47:07Z
updated: 2023-09-27T07:40:29Z
type: memo
title: Python Virtual Environments
---
sd21-06-2023 11:57

Tags: #python #venv 


---
### Creating and loading a venv

Create or navigate to the folder where the environments will be stored

Install venv
```Bash
sudo apt install python3.10-venv
```

Create an environment
```Bash
python -m venv <env-name>
```

Load an environment (Linux)
```Bash
source <env-name>/bin/activate
```

Load an environment (Windows)
```Bash
./<env-name>/scripts/activate.ps1
```

Deactivate the environment
```Bash
decativate
```

---
## References