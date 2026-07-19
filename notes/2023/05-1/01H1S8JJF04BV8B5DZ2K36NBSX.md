---
id: 01H1S8JJF04BV8B5DZ2K36NBSX
created: 2023-05-31T15:59:40Z
updated: 2023-05-31T15:59:40Z
type: memo
title: k3s Common Commands
---
31-05-2023 16:58

Tags: #k3s #kubernetes  


---
Guide
https://man.ilayk.com/man/k3s/

List images
```
sudo k3s crictl images
```

Delete images not currently in use
```Bash
sudo k3s crictl rmi --prune
```

---
## References