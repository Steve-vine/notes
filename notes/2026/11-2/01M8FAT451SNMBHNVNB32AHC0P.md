---
id: 01M8FAT451SNMBHNVNB32AHC0P
created: 2026-11-27T20:23:08.193833Z
updated: 2026-11-27T23:40:11.959342Z
type: task
title: 'Servers join with one install per company: a joining code, Windows and Linux install scripts that fetch osquery from the agent door, directory matching, and Waiting to join for anything else'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2204
sprint: smfrbak
blocked_by:
- 01M8FASC8E9JHHQ9AZ8726MBSF
assignee: steve
label:
- feature
priority: high
task_status: active
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