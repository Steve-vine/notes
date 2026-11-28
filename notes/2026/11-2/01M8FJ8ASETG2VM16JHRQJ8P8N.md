---
id: 01M8FJ8ASETG2VM16JHRQJ8P8N
created: 2026-11-27T22:33:13.774808Z
updated: 2026-11-28T07:56:47.382624Z
type: task
title: 'Linux exact matching: each Linux server''s installed packages are compared with its own distribution''s fixed versions, so a server lists exactly which security fixes it''s missing'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2215
sprint: s51yxk5
blocked_by:
- 01M8FJ7TFNQFWW8YNYWRTBFJFY
- 01M8FATKBRPVSNTVEM5E7C89ZT
comments:
- id: 01M8GJG569DYAYN2WXH2GQDXCD
  author: Steve Vine
  at: 2026-11-28T07:56:44.617245Z
  text: |-
    Built: PR #2227, merged to main (not on staging yet; it goes with the sprints' deploy).

    What's there:
    - Each Linux server's packages are compared with its own distribution and release's fixed versions, by that distribution's own rules (dpkg for Ubuntu and Debian, rpm for Red Hat, Rocky and Alma).
    - A Linux server's Patch level card lists its missing security fixes, each linking to its feed item: "CVE-2026-1001 · High · distribution: Medium · openssl 3.0.2-0ubuntu1.15 → 3.0.2-0ubuntu1.18 · USN-9000-1 · released …". Otherwise it says "none missing".
    - A separate "No fix available yet" list, folded away, shows CVEs the distribution hasn't fixed for that release. They're visible, but kept apart from what can be patched.
    - A release the distribution data doesn't cover reads "This release isn't covered by the distribution data: can't tell exactly…".
    - On the Security Feed item, "Everything we run" reads "Affects us: exact match" per release ("Ubuntu 22.04"), with each server's package and version. A server that has the fix appears under "Why it doesn't match what we run" as "not affected, exact match".
    - When a server's packages change, its company's matches are worked out again.

    One thing differs from the task: cloud servers (AWS Systems Manager, Azure Change Tracking) aren't judged exactly. Their package lists don't keep the source package or the release, so only servers reporting through the agent are. Cloud servers keep the "possible" route.

    For you to look at: on staging, the Ubuntu test server once its packages are read. I'll check this in the pre-UAT pass.
assignee: steve
label:
- feature
priority: high
task_status: review
---
**On the chain** (API, possibly columns on discovered software). ADR 0188. After COM-2214, and needs the Server Agent sprint's package lists (COM-2205).

## What people see
- On a Linux server's **Patch level**, a **Missing security fixes** list: each CVE with severity (the distribution's and NVD's), known-exploited flag, the package, the installed version and the fixed version ("openssl 3.0.2-0ubuntu1.15 → 3.0.2-0ubuntu1.18 · USN-7123-1"). Or **None missing**.
- A separate, collapsed **No fix available yet** list for CVEs the distribution hasn't fixed for that release (e.g. "deferred"), so they're visible but not mixed with what can be patched.
- On the Security Feed item, the server reads **Affects us — exact match** or **Not affected — exact match**.
- A Linux server on a distribution or release the source doesn't cover (e.g. CentOS 7, Ubuntu 18.04 without Pro) reads "This release isn't covered by the distribution data: can't tell exactly".
- Works for cloud Linux servers too, wherever their discovery reports packages with full versions (AWS SSM Inventory, Azure Change Tracking).
- No vulnerabilities are raised by this task; automatic raising is the next task.

## Notes (technical)
- Each package row needs: **source package name**, **full version** (epoch:version-release, or Debian's version with revision) and the server's **distribution and release**. osquery: `deb_packages` (`name`, `version`, `source`, `arch`), `rpm_packages` (`name`, `version`, `release`, `epoch`, `source`), `os_version` (`platform`, `version`, `codename`). If COM-2205 doesn't keep `source`/epoch/release, add them (columns on `DiscoveredSoftware` or a companion table) and make sure ADR 0114's update filter and product+major grain don't drop or merge Linux packages.
- Match per server: its ecosystem + release → distribution fixes for the source package (COM-2214) → compare installed full version with the fixed version using the ecosystem's rules (dpkg / rpm). Installed < fixed → missing; ≥ → not affected; status without a fixed version → no fix yet.
- Results kept per server per item, recomputed when the feed or the server's read changes (shared with COM-2213's per-server results).
- Cloud sources: map SSM / Change Tracking package fields where they give full versions; otherwise "can't tell exactly".

**Done when:** on staging, a test-rig container pinned to an older OpenSSL (or another package with a published fix) lists that CVE under Missing security fixes with installed and fixed versions; after the package is upgraded in the container and Read now, it's gone; CI covers Ubuntu, Debian and Rocky examples including an epoch and a `~` version.