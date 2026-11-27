---
id: 01M8FAP9NFYXKQY1TFM732PFRP
created: 2026-11-27T20:21:02.767705Z
updated: 2026-11-27T22:14:58.307143Z
type: task
title: 'ADR 0187: the server agent — on-premises servers report through osquery to a narrow public door; Compass reads, never acts'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2202
sprint: smfrbak
assignee: steve
label:
- brief
priority: high
task_status: review
---
**Independent** (decision record only).

Steve, 27 Nov 2026, opening sprint 130 "Server Agent": gather information from servers that aren't in the cloud — **installed software, patch levels and configuration checks**. Setup must be easy: one package pushed to every server with Automox and kept up to date the same way, with no per-server ID or configuration. The servers don't run Twingate, so the agent reaches Compass through a **public** address; they go out through **fixed public IPs**, so that address accepts only those.

Agreed in conversation:
- The agent is **osquery**, unchanged; Compass is its server (not Fleet, not Wazuh). OpenSCAP is out (no real Windows support), so configuration checks are osquery queries Compass ships.
- One identical install per company: Compass's address and that company's **joining code** built in. Each server gets its own key automatically on first contact.
- A **separate public host** with only the agent's requests behind it (the Vendor Portal pattern, through a Cloudflare Tunnel at Moneypenny); main Compass stays private. Source addresses limited to the fixed IPs.
- A new server joins automatically only if it matches a server already found in Active Directory; anything else waits for a person. No silent replacement of a server that already reports.
- The agent only reads. Scripts never go through it (ADR 0185's rejection of an agent that runs scripts stands).

Reverses, deliberately: ADR 0099 §6 / ADR 0108 §1 (no agent of Compass's own) and ADR 0114 §6 (software only from agents the clouds already run).

**Done when:** ADR 0187 is on main as Proposed, with my calls listed for Steve to confirm or overturn.