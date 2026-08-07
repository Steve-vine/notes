---
id: 01KZ9MVNRT58CRHW4BQ3SQWAH4
created: 2026-08-05T19:02:01.754361Z
updated: 2026-08-07T10:57:23.36754Z
type: task
title: 'ADR 0084: Servers integration — agentless Ansible execution, register-first fleet'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 563
sprint: sesjg7z
comments:
- id: 01KZ9VM504FDM3BVDJYVW3YB93
  author: Steve Vine
  at: 2026-08-05T21:00:15.235862Z
  text: |-
    ⚠️ ADR NUMBER COLLISION — this task must renumber to 0087.

    This body reserves 0084 on the basis that "0083 is taken on main". That was true when it was written, but Sprint 47 (Integration Decoupling, ISE-495..499, built 2026-08-05) has since taken FOUR numbers, all now on branches with open PRs and merged into staging:

    - 0083 — Connectors declare their own System-detail summary (ISE-495/496, PRs #482/#484)
    - 0084 — Tag writeback is declared by the connector, not mapped centrally (ISE-497, PR #485)
    - 0085 — Connectors declare their own sweep cadence (ISE-498, PR #486)
    - 0086 — A canonical vocabulary is served through the contract, never hand-copied (ISE-499, PR #487)

    So the Servers integration ADR should be **0087** — `docs/decisions/0087-servers-integration-agentless-ansible.md`. Nothing else in the task changes; only the number and the filename.

    Worth noting for the next time two sprints plan in parallel: `docs/decisions/README.md`'s index was ALSO stale (it stopped at 0076 — 0077, 0078, 0081 and 0082 were all committed but unlisted), so "what is the next free number?" could not be answered from the index alone. Sprint 47 added its four rows; backfilling 0077/0078/0081/0082 is still outstanding, and 0079/0080 remain untracked drafts on the voice-escalation sprint.
- id: 01KZAX6DMTG6M0DSN5MFGFVAMZ
  author: Steve Vine
  at: 2026-08-06T06:46:56.92231Z
  text: |-
    RESOLVED — no action needed here. **This ADR keeps 0084.**

    Correcting my earlier comment: it assumed this task was still unwritten, but PR #483 had already merged to main (commit `f513372`) while Sprint 47 was in review. First to main keeps the number, so `docs/decisions/0084-servers-integration-agentless-ansible.md` stands as-is.

    **ISE-497's tag-writeback ADR renumbered to 0087 instead** (PR #485), since 0085/0086 were already taken by its sibling tasks and cited in commits and the Canon.

    Root cause fixed in **PR #488**: `docs/decisions/README.md` had stopped at 0076 — 0077, 0078, 0081, 0082 and this one were all committed but unlisted, so "what is the next free number?" could not be answered from the index. Backfilled, and the preamble now carries the rule: take the next number from the FILES and the OPEN BRANCHES, never the table alone, because a number is reserved when an ADR is drafted but only appears in the index when it merges — so a gap means an ADR is in flight, not a free number.

    0079/0080 remain deliberately unindexed: they are the voice-escalation sprint's untracked drafts, so indexing them would point rows at files main does not have.
assignee: steve
label: null
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