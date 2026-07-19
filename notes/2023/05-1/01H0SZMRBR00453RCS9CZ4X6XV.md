---
id: 01H0SZMRBR00453RCS9CZ4X6XV
created: 2023-05-19T12:27:07Z
updated: 2023-05-19T12:30:43Z
type: memo
title: Run Ansible Playbook
---
19-05-2023 13:26

Tags: #ansible  


---
Run a playbook
```Bash
ansible-playbook playbooks/apt.yml --user steve --ask-pass --ask-become-pass -i /inventory/hosts
```

---
## References