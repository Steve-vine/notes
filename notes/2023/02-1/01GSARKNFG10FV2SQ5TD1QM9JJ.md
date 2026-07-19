---
id: 01GSARKNFG10FV2SQ5TD1QM9JJ
created: 2023-02-15T14:45:42Z
updated: 2023-02-15T14:45:42Z
type: memo
title: Check is a Port is Open Between Two Linux Boxes
imported_from: Obsidian
---
15-02-2023 14:43

Tags: #linux #netcat

# Check is a Port is Open Between Two Linux Boxes

---
On the first box
```Bash
nc -l 8080
```

On the second box
```Bash
nc 10.0.0.1 8080
```

Anything types into one console should appear on the other

---
## References