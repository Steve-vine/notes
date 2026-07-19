---
id: 01GSJ14YJGZ346HZVJNGR66YZR
created: 2023-02-18T10:29:38Z
updated: 2023-02-18T10:34:31Z
type: memo
title: Bypass Windows 11 Setup Tests
imported_from: Obsidian
---
18-02-2023 10:29

Tags: #windows11 #tpm 

# Bypass Windows 11 Setup Tests

---
After receiving the install error press SHIFT + F10 for command prompt
regedit
got to HKEY_LOCAL_MACHINE/SYSTEM/Setup
Create three new DWord registry keys

BypassTPMCheck
BypassSecureBoot
BypassRAMCheck

Each with a value of 1

Exit regedit, command prompt and setup, the rerun setup

---
## References