---
id: 01JW1CMMYMYPFZDN245Y0KAEMG
created: 2025-05-24T14:55:03.636Z
updated: 2025-06-08T12:36:06.055999Z
type: memo
title: Fix apt-get update Failure
---
24-05-2025 15:55

Tags: #proxmox 


---
### Error Message

In Proxmox you see the error:
TASK ERROR: command 'apt-get update' failed: exit code 100

When running update manually through the shell you get
```
root@pve:~# apt get update
E: Invalid operation get
root@pve:~# apt-get update
Get:1 http://security.debian.org bookworm-security InRelease [48.0 kB]
Hit:2 http://ftp.uk.debian.org/debian bookworm InRelease                              
Get:3 http://ftp.uk.debian.org/debian bookworm-updates InRelease [55.4 kB]
Err:4 https://enterprise.proxmox.com/debian/ceph-quincy bookworm InRelease
  401  Unauthorized [IP: 51.91.38.34 443]
Err:5 https://enterprise.proxmox.com/debian/pve bookworm InRelease
  401  Unauthorized [IP: 51.91.38.34 443]
Reading package lists... Done
E: Failed to fetch https://enterprise.proxmox.com/debian/ceph-quincy/dists/bookworm/InRelease  401  Unauthorized [IP: 51.91.38.34 443]
E: The repository 'https://enterprise.proxmox.com/debian/ceph-quincy bookworm InRelease' is not signed.
N: Updating from such a repository can't be done securely, and is therefore disabled by default.
N: See apt-secure(8) manpage for repository creation and user configuration details.
E: Failed to fetch https://enterprise.proxmox.com/debian/pve/dists/bookworm/InRelease  401  Unauthorized [IP: 51.91.38.34 443]
E: The repository 'https://enterprise.proxmox.com/debian/pve bookworm InRelease' is not signed.
N: Updating from such a repository can't be done securely, and is therefore disabled by default.
N: See apt-secure(8) manpage for repository creation and user configuration details.
```

This is because Proxmox tries to use the enterprise repo by default and you don't have an enterprise subscription, so the server IP is not authorised.

### Change Proxmox to use the Community Repo

In the console, go to pve->updates->repositories and remove the Enterprise repos.

Open up the shell and edit the repo list
```
nano /etc/apt/sources.list
```

Add the following line
```
deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription
```
Save and exit nano

Now update and upgrade the repo
```
apt update
```

```
apt dist-upgrade
```

---
## References