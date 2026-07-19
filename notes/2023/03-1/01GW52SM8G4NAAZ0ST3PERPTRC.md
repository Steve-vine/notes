---
id: 01GW52SM8G4NAAZ0ST3PERPTRC
created: 2023-03-22T16:35:22Z
updated: 2023-03-22T16:35:22Z
type: memo
title: Remove Proxmox Subscription Warning
imported_from: Obsidian
---
22-03-2023 16:33

Tags: #proxmox


---
Log into PVE server via SSH and run
```Bash
sed -Ezi.bak "s/(Ext.Msg.show\(\{\s+title: gettext\('No valid sub)/void\(\{ \/\/\1/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js && systemctl restart pveproxy.service
```

Log out, close browser and log back in again.

---
## References