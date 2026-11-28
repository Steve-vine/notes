---
id: 01M8FAT451SNMBHNVNB32AHC0P
created: 2026-11-27T20:23:08.193833Z
updated: 2026-11-28T00:27:29.284357Z
type: task
title: 'Servers join with one install per company: a joining code, Windows and Linux install scripts that fetch osquery from the agent door, directory matching, and Waiting to join for anything else'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2204
sprint: smfrbak
blocked_by:
- 01M8FASC8E9JHHQ9AZ8726MBSF
comments:
- id: 01M8FRSGMZ6HNNK5AB7EV8VHTF
  author: Steve Vine
  at: 2026-11-28T00:27:28.287165Z
  text: |-
    Built: PR #2215, merged to main (not on staging yet; it goes with the sprint's deploy).

    What's there:
    - Admin ▸ Integrations ▸ Server agent now also shows "Servers from the agent" for the company chosen at the top of the screen, for Inventory admins. Switch the agent on, and Compass makes the company's joining code (shown on request, changeable, listed in the Secrets register).
    - Two install scripts to download: Windows (PowerShell) and Linux (Bash, for both dpkg and rpm). Each downloads osquery 5.24.1 from the agent address itself, checks its checksum (and its signature on Windows) before installing, writes the settings (including the ones that keep the agent read-only) and the joining code, and restarts osquery. Running the same script again upgrades osquery and keeps the server's key, so Automox can push it as-is.
    - A server whose name matches a server the directory already found for the company joins by itself. Anything else waits under "Waiting to join" with the reason: not in the directory, a name matching several servers, or "SRV01 already reports through the agent; last seen …". Accept, Replace the old one, or Refuse; a refused server can't join again. Reporting servers show last seen, Not reporting after 24 hours, Out of date when on an older osquery, and Remove.
    - An optional certificate authority for the agent address, install-wide. Empty means the public authorities osquery ships with, which is right behind Cloudflare.

    Tested for real: the Linux script, run in an Ubuntu container against a TLS copy of the door, downloaded osquery from Compass, installed it, and the server joined. The Windows script parses cleanly in PowerShell, but I couldn't run it on a real Windows server.

    For you to look at:
    - Run the Windows script on a test server (Couldn't check for me).
    - Staging needs the agent address and the test servers (COM-2208) before you can see it there.
assignee: steve
label:
- feature
priority: high
task_status: review
---
**On the chain** (new tables and API). ADR 0187 §4, §6, §9. After COM-2203.

## What people see
- **Inventory ▸ Discovery settings ▸ Servers from the agent** (beside "Servers from the directory"; whoever can change that company's discovery settings):
  - **Switch on the server agent for this company.** Until the install has an agent address and allowed addresses (COM-2203), it says what's missing and links there.
  - **Joining code**: made by Compass, shown on request, **Change code** (with a confirmation: "Servers that have joined keep reporting. Only new installs need the new code."). It appears in the Secrets register like Compass's other credentials.
  - **Install**: **Windows (PowerShell)** and **Linux** scripts to download or copy, each with the agent address, the code and the trusted certificate authority built in, plus a short "Push this with Automox, Group Policy or Intune; run it again to upgrade."
  - **Waiting to join**: servers that matched nothing, each with name, domain, operating system, source address and first seen, and why it's waiting ("Not found in the directory for this company" / "SRV01 already reports through the agent; last seen 10 minutes ago"). **Accept**, **Replace the old one** (for a second claim) or **Refuse**.
  - **Reporting servers**: name, the directory server it's matched to, osquery version, last seen, and **Not reporting** (no check-in for 24 hours) or **Out of date** (older osquery than Compass names). **Remove** stops a server's key.
- A server whose DNS host name matches a server found in the directory, in this company's scope, **joins without anyone doing anything**.
- Joining, accepting, refusing, replacing, removing and changing the code are all in the activity log.

## Notes (technical)
- Per-company agent connection with `RegisteredConnectionMixin` (`__provider__ = "agent"`, new `PROVIDER_AGENT` in `models/discovery.py`), so it joins `discovery_connections` (ADR 0104 §11); register it in `core/discovery/sources.py`. Joining code encrypted via `core/secretbox.py`; enroll compares in constant time.
- **Packages:** Compass keeps the pinned osquery release (version + SHA-256 for the Windows MSI and Linux deb/rpm, x64 and arm64) in code. The backend fetches each from the official release on first request and serves it from the attachment store, verifying the SHA-256 before storing; the agent door serves it at the downloads path. Never fetch an unpinned version.
- **Scripts** are rendered per company from a template: download from the door, check SHA-256 (and Authenticode on Windows, `Get-AuthenticodeSignature` signer = osquery's), install, write `osquery.flags` (tls_hostname, enroll_secret_path, tls_server_certs, host_identifier=uuid, config/distributed/logger plugins = tls, distributed interval 300s, `--disable_carver=true`, `--disable_tables=curl,curl_certificate,carves`), write the secret file readable by SYSTEM/root only, then (re)start the service. Idempotent; re-running upgrades and keeps the node key (osquery's database).
- **Matching** at enroll: host identity from osquery's `host_details` (hostname, uuid) plus a first distributed query (`system_info`, `os_version`, domain from registry or `kernel_info`) — decide in the PR. Match case-insensitively on FQDN, then short name within the company's directory-discovered servers (`provider=directory`, in scope). A match links the node to that `DiscoveredResource`; accept-unmatched creates a `DiscoveredResource` with `provider=agent`, `native_id` = hardware UUID.
- Second claim (same FQDN or UUID as an active node) → waiting, never replaces.
- Not reporting / out of date computed from last seen and version.

**Done when:** on staging, with the test rig (COM-2208), a container agent installed by the Linux script joins the E2E Test Company and shows under Reporting servers; one whose name matches nothing waits and can be accepted or refused; a second install claiming the same name waits with the "already reports" reason; changing the code stops new joins with the old one but leaves joined servers reporting.