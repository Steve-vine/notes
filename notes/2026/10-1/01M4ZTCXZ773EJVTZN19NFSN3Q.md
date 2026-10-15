---
id: 01M4ZTCXZ773EJVTZN19NFSN3Q
created: 2026-10-15T13:00:36.711577Z
updated: 2026-10-15T13:00:41.294707Z
type: task
title: The assistant can read and work the Risk register — write a risk as cause, event and consequence, score it, plan its treatments, and link it to controls and gaps
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 981
sprint: sadf3j6
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 70, Content - Build MCP (ADR in COM-974). Built on COM-975. Uses COM-977's control lookup, and links to gaps from COM-980. Posture batch.

## What people can ask of it

- **Read, for a named company:**
  - the risk register, filtered as on screen (tier, score, owner, status, treatment);
  - a risk in full: cause, event and consequence, likelihood and impact by their level names, inherent and residual score, treatments, revision history;
  - the controls, gaps, technology assets and vendors linked to it;
  - the risk overview figures.
- **Write (whatever the person's role allows on the Risks screen):**
  - add a risk;
  - edit it, including its scoring;
  - add, change and remove treatments;
  - link and unlink controls and gaps.
- **Claude's call:** linking a risk to a **technology asset or vendor** stays on screen. Those belong to Inventory and Vendor Management, which are out of scope. The assistant reads those links but doesn't make them.
- **Example:** "Write up a risk for Acme: unpatched VPN appliance, likely 4, impact 5, owner IT Ops; link it to the vulnerability-management control and the open patching gap, and add a treatment to replace it by year end."

## Notes (technical)

- These wrap `risks.py`, `risk_treatments.py` and `risk_overview.py`, and read `risk_rubric.py` and `risk_tiers.py` so scoring uses the level names people see.
- `risk_attachments.py` is read as names plus links only (no uploads).
- A risk edit writes a revision. Check that it carries the via-assistant marker (COM-975's column).

**Done when:** on staging, the assistant writes and scores a risk, adds a treatment and links a control and a gap, and the risk page shows it all, via assistant.