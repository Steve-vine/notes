---
id: 01M0885AJ0E38GKHXS8ADN8T1T
created: 2026-08-17T16:16:33.856545Z
updated: 2026-08-18T12:50:51.246272Z
type: task
title: Access Control inception + ADR 0045
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 235
sprint: s5gwx0s
comments:
- id: 01M08HJBX3VWVEN33RWJZMJ5GN
  author: Steve Vine
  at: 2026-08-17T19:00:58.403636Z
  text: 'Done — ADR 0045 written and merged to main (PR #235, squash 2d385d1). The ADR settles the vocabulary (app role / business role / directory role; Compass user vs directory user), the entity model (entra_settings singleton, global directory mirror of security groups only, company-scoped role matrix defining "managed" groups, batch-aware access_requests with standard + expedited lifecycles, recert campaigns with snapshot-at-open, unrequested-change items), the write-scope blast-radius mitigations (one grep-provable Graph write path, maker-checker on every write, role-assignable groups and privileged accounts refused at both ends), out-of-band detection, tenancy, the three new app roles and the Access nav section. Planning decisions from the sprint description were carried in unchanged; schema lands task by task from migration 0060.'
assignee: steve
label:
- brief
priority: high
task_status: done
---
A genuinely new domain area — nothing in the briefs or ADRs models it — so, per the convention established by 0021/0023/0024/0025 and the shape proven by ADR 0039 (vendors): **one full-domain ADR now, schema landing incrementally with each task**.

ADR 0045 must settle:

* **Vocabulary.** Three meanings of "role" now collide: Compass app roles (ADR 0026), the matrix's **business roles**, and Entra directory roles. Pin distinct names in code and UI before the first migration (working names: `business_role` for the matrix; "role" unqualified stays ADR 0026's). Likewise "user": ADR 0007's Compass users vs the Entra **directory users** this feature governs — two identity domains, say so explicitly.
* **Entity model.** Connection settings singleton; directory mirror (users/groups/memberships); company-scoped `business_roles` + role↔group mappings; JML/change request with a module-level allowed-transitions map (ADR 0039 §2 — no state-machine engine); recert campaigns + review items, with membership snapshotted at campaign open (the ADR 0015 §4 revision pattern — "what did this look like last quarter" is the audit question). Change kinds include **group creation** (both approval modes), not just user lifecycle + membership — incident-time work creates groups too.
* **Blast radius + maker-checker.** ADR 0034 accepted "app identity exceeds user identity" at read scope (`Sites.Selected`); at `User.ReadWrite.All`/`Group.ReadWrite.All` it is a privilege-escalation path. Record the mitigation: no Graph write without a second person's involvement; exact permission list; excluded/protected groups (e.g. anything holding privileged directory roles) Compass refuses to manage.
* **Expedited (break-glass) changes** *(planning amendment 2026-08-17)*. Incident-time work can't wait for pre-approval, so maker-checker is **reordered, not waived**: a restricted third role (`access_engineer`) raises and executes in one step (`approval_mode = expedited`, lifecycle `submitted → executed → pending_validation → validated | amended`), with requester = approver = executor recorded explicitly and visibly. A **different person** must validate after the fact — confirm the object was provisioned correctly (description sensible, right groups), or **amend and validate** (the amendment executes through the same write path, linked to the original; the pair closes together — two humans have seen the end state). Validation has teeth: an SLA (default 5 business days), overdue nagging via the reminders engine, a dashboard presence, and the expedited:standard ratio surfaced — if everything goes expedited the control is dead. Companion control: **out-of-band detection** — the mirror sync diffs reality against Compass-executed changes; unrequested creations/changes join the same validation queue for adoption or reversal (COM-244).
* **Tenancy.** Global tenant connection (the `m365_settings`/ADR 0044 §1 precedent), company-scoped governance data (the vendors precedent).
* **IA (ADR 0017).** Connection config lives in Admin ▸ Integrations beside M365 and Email; the role matrix / JML / validation / recert screens are a new role-gated **Access** nav section (the ADR 0039/0040 sectioning precedent).

Decisions already settled at sprint planning (2026-08-17) are recorded on the sprint description — carry them into the ADR, don't re-open them.