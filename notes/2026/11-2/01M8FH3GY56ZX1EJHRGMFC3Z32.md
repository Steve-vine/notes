---
id: 01M8FH3GY56ZX1EJHRGMFC3Z32
created: 2026-11-27T22:13:07.653442Z
updated: 2026-11-28T00:29:13.041381Z
type: task
title: 'Linux server configuration checks: built-in checks modelled on the CIS Linux benchmarks (SSH, accounts, firewall, services, SELinux/AppArmor, audit, time, kernel), sharing the cross-platform checks with Windows'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2210
sprint: smfrbak
blocked_by:
- 01M8FAVGBYEAE17CNZBWV1KZEE
assignee: steve
label:
- feature
priority: high
task_status: active
---
**On the chain** (checks, settings, API). ADR 0187 §8 (as amended for Linux). After COM-2207. Steve, 27 Nov 2026: "add configuration checks for Linux."

## What people see
- The **Servers** check group covers **Linux servers** too. Ubuntu/Debian and Red Hat–family (RHEL, Rocky, Alma) are supported; another distribution reads **Couldn't tell** where a fact isn't where those keep it.
- **Checks that mean the same on both run on both** (one check, one result per server, whatever its operating system). COM-2207 builds these to apply to Windows; this task gives each its Linux rule:
  - **Host firewall is on** (Windows Firewall every profile / on Linux: firewalld, ufw or nftables active with rules loaded).
  - **Administrators hold only allowed members** (local Administrators / on Linux: the `sudo`, `wheel` and `admin` groups, plus anyone with a sudoers rule). Allowed Linux members are a separate per-company list.
  - **Minimum password length** meets the company's value (on Linux: `minlen` in pwquality).
  - **An update has been installed within the company's days** (on Linux: the newest package install date, from COM-2206).
  - **Coverage** stays as it is (servers the directory found; Linux servers off the domain join by being accepted).
- **Linux-only checks:**
  1. SSH doesn't allow root to sign in (`PermitRootLogin no`, or `prohibit-password` if the company allows keys for root: a setting, default no).
  2. SSH doesn't allow password sign-in (`PasswordAuthentication no`).
  3. Only root has user ID 0.
  4. No account has an empty password.
  5. No telnet, rsh/rlogin, TFTP or plain FTP server is running.
  6. Mandatory access control is enforcing (SELinux enforcing, or AppArmor enabled with profiles in enforce mode).
  7. The audit daemon (auditd) is running.
  8. Time synchronisation is running (chrony, systemd-timesyncd or ntpd).
  9. Kernel hardening: address-space randomisation is full (`kernel.randomize_va_space = 2`) and IP forwarding is off (a server can be marked as a router, like *print server* on Windows).
- **Windows-only checks stay Windows-only** (SMBv1, Guest, RDP, Defender, TLS 1.0/1.1, Print Spooler); a Linux server reads **Doesn't apply** for them, never a fail.
- **Disk encryption isn't checked on Linux** in this task: on-premises Linux servers rarely encrypt their system disk, and which volume holds data can't be told reliably. *(My call; say if you want it.)*
- Results, evidence on controls, gaps (ADR 0159), the server's **Configuration** section and per-company settings work exactly as COM-2207's.

## Notes (technical)
- Same `core/checks/servers.py` group; each cross-platform check gets an OS-specific query + rule, chosen by the server's reported platform. Linux-only checks declared alongside.
- osquery sources: `augeas` (Linux) for `/etc/ssh/sshd_config` (and `sshd_config.d/*.conf` includes: first match wins, as sshd does), `/etc/security/pwquality.conf`, `/etc/sudoers` + `sudoers.d`; `users` (uid), `shadow` (`password_status`; never hashes); `groups`/`user_groups`; `systemd_units` (firewalld, ufw, nftables, auditd, chronyd, systemd-timesyncd, ntpd, telnet/rsh/tftp/vsftpd sockets and services) cross-checked with `listening_ports`; `iptables` / nft rule presence; `selinux_settings`, `apparmor_profiles`; `system_controls` for sysctls.
- Switch off nothing new: `augeas` and `shadow` are plain reads; ADR 0187 §2's list (carver, curl tables) is unchanged. The `shadow` table must never be sent back with hash columns: select only `username, password_status`.
- Map controls to existing library controls (secure configuration, privileged access, logging, clock synchronisation, network security). Update the tests that pin built-in check counts and links.

**Done when:** in CI, every Linux rule is tested against recorded osquery output from a compliant and a non-compliant Ubuntu 24.04 and Rocky Linux 9 server; on staging the test-rig servers (COM-2208, Linux) show results for each Linux check, with service-based checks reading Couldn't tell where a container has no systemd, never a false pass; Windows-only checks read Doesn't apply for them. Steve checks one real Linux server (Couldn't check for me beyond the rig).