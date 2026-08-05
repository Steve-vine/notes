---
id: 01KZ9MVNRT58CRHW4BQ3SQWAH4
created: 2026-08-05T19:02:01.754361Z
updated: 2026-08-05T19:05:59.737513Z
type: task
title: 'ADR 0084: Servers integration — agentless Ansible execution, register-first fleet'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 563
sprint: sesjg7z
assignee: steve
label:
- brief
priority: high
task_status: backlog
---
Record the architecture for the Servers integration (Windows + Linux via Ansible), agreed in planning 2026-08-04/05. Draft on `feature/ise-563-servers-adr` — `docs/decisions/0084-servers-integration-agentless-ansible.md`, status Proposed. **0083 is taken on main** — 0084 is ours.

Decisions the ADR must carry:

- **Execution channel: ISE runs Ansible itself** — ansible-runner in the Celery worker. Semaphore is dead (no longer planned to be deployed, confirmed 2026-08-04) and would have broken the ADR 0017 catalogue contract anyway: a task template is a mutable black box owned outside ISE, so tier declarations become fiction (the Power Automate shape). No AWX/AAP either.
- **No `run_playbook` / `run_command` primitive, ever** — every operation is a small ISE-authored playbook/module call, declared, tiered, reviewed at PR time.
- **Register-first inventory** — the server register is the definitive fleet list (Ansible is agentless: inventory is an *input*, not a discovery output). Multi-source **coverage reconciler** audits it (Arc, EC2, Azure VMs, EntraID devices, Hyper-V guests — ISE-566/569/570). Cloud-VM registration **binds to the existing entity, never mints a duplicate**; list-only sources mint on confirm.
- **read-state split** — small synced identity-facts snapshot (doubles as the liveness sighting) + full facts/service state as on-demand Evidence (ISE-565/567). Entity keys join on **hostname** (the DataDog join; K8s-node precedent) so the unknown-asset back-fill re-links existing DD alerts.
- **detect: Observations, never Alerts** (no native detection layer to defer to — the Freshservice precedent). v1: unreachable-past-threshold.
- **act v1: four ops, all T2** (ISE-568/571) — restart/start/stop service, reboot. Reboot deliberately NOT the EC2 T1: an on-prem server that doesn't come back is a site visit; per-system policy raises to T3 for DCs/Hyper-V hosts. `--check --diff` preview attached to the ProposedChange.
- **Both platforms from day one for connectivity/facts** (the inherited Arc fleet — 39 machines — is heavily Windows); act lands Linux-first (ISE-568) with Windows a ticket behind (ISE-571).
- **Connection profiles** — named credential + connection config (method/port/become) assigned per server, optional per-OS-family default; read/write split at profile level; lands on the post-ISE-553/554 credential-binding pattern.
- **Onboarding requirements** — nothing installed on the target. Resolvable name, network path (native or Twingate sidecar), pre-deployed credential; Linux: SSH + Python 3; Windows: WinRM listener + auth (Kerberos preferred, krb5 in the worker image). Categorised preflight failures.

Also: record the ruling in the ISE Canon (standing instruction) — done as a comment on the Canon memo 2026-08-05.

**Acceptance**: ADR merged to main as 0084; connectors brief table gains the Servers row.