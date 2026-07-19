---
id: 01GVBG5TMG4QTHG6DJGX1QECTR
created: 2023-03-12T18:08:58Z
updated: 2023-03-12T18:10:38Z
type: memo
title: Install TalosCTL on MacOS M1
imported_from: Obsidian
---
12-03-2023 18:09

Tags: #talosctl #mac 

# Install TalosCTL on MacOS M1

---
Download the latest version
```Bash
curl -Lo /usr/local/bin/talosctl https://github.com/talos-systems/talos/releases/latest/download/talosctl-$(uname -s | tr "[:upper:]" "[:lower:]")-arm64
```

Make the file executable
```Bash
chmod +x /usr/local/bin/talosctl
```

---
## References