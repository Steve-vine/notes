---
id: 01M8FASC8E9JHHQ9AZ8726MBSF
created: 2026-11-27T20:22:43.726808Z
updated: 2026-11-27T20:22:43.726808Z
type: task
title: 'The agent door: a separate public address that serves only osquery''s requests, from allowed IP addresses only, with Admin ▸ Integrations ▸ Server agent showing its health'
label: feature
task_status: todo
priority: high
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2203
---
**On the chain** (new tables and API). ADR 0187 §1–§3 (COM-2202). First build task of the sprint.

## What people see
- **Admin ▸ Integrations ▸ Server agent** (new, *manage integrations*): "On-premises servers report to Compass through osquery, over a separate public address that serves nothing else."
  - **Agent address**: the one the install's settings provide, read-only on screen. With none set: "The server agent isn't published on this install" and nothing else works.
  - **Allowed addresses**: the public IP addresses and ranges servers go out through (IPv4/IPv6, CIDR). With none: "The agent address refuses every request until you add the addresses your servers go out through." A hint says to add the same list as a firewall rule in front (a Cloudflare rule at Moneypenny).
  - **osquery version**: the one this Compass release supports (read-only).
  - **Health**: last request, and refusals in the last 24 hours by reason (address not allowed, unknown server, rate limited).
- Everything changed is in the activity log.
- **Nothing changes for main Compass**, which stays on its private address.

## Notes (technical)
- **Chart:** `config.agentPublicUrl` + `agent.ingress.*` (off by default), mirroring `vendorPortal.ingress` / `assistantPublicUrl`. In `chart/templates/frontend/configmap-nginx.yaml`, map the agent host and on it serve only the agent API prefix (e.g. `/api/agent/`) and the downloads path (COM for joining); everything else returns 404, `/api/v1` included. Document it in `chart/README.md` and `NOTES.txt` (Cloudflare Tunnel route).
- **Backend:** a new router mounted outside `/api/v1` and all session guards (like `api/vendor_portal`), implementing osquery's TLS remote API: enroll, config, distributed read, distributed write, log (accept and drop, or keep the status log for health). Node key auth: random key issued at enroll, **only a hash stored**.
- **Source address check** before anything else: the client address comes from a proxy header named in chart values (`agent.trustedProxyHeader`, e.g. `CF-Connecting-IP`), only when the immediate peer is a trusted proxy range from values; otherwise the peer address. Empty allow-list = refuse all.
- **Rate limits** on enroll (per source address and per company) and on check-ins (per node), backed by Valkey.
- The config Compass sends is built in code, never from free text. The flags that switch off carving and the curl tables are written by the install script on the command line (ADR 0187 §2), so config can't re-enable them.
- New model(s): install-wide agent settings (allowed ranges), agent nodes (node key hash, company, discovered resource link, host identity, version, last seen, status). The per-company connection lands with the joining task; keep nodes ready to point at it.
- Integration test with a **real osquery** (Linux package in a test container) enrolling against the test server: refused from a non-allowed address, refused with a wrong code, accepted with a right one.
- ADR 0154 §1 line on the Integrations screens: the server agent is **Read only** (COM-1841's kind label).

**Done when:** on staging, the agent host answers osquery's requests and 404s `/api/v1`; a request from an address not on the list is refused and counted under Health; and CI's real-osquery test joins and checks in.