---
id: 01JYY4801VQW0WQSK1XVNTBF3W
created: 2025-06-29T15:17:42.587Z
updated: 2025-06-29T15:19:32.614Z
type: memo
title: Resize root volume to use all available space
imported_from: Obsidian
---
29-06-2025 16:17

Tags: #linux 


---
Check the current size
```
df -h /
```

Use all remaining space in the volume group
```
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
```

 Resize the filesystem (ext4)
```
sudo resize2fs /dev/ubuntu-vg/ubuntu-lv
```

Check the current size again
```
df -h /
```


---
## References