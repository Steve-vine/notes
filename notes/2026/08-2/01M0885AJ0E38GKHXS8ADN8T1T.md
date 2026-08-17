---
id: 01M0885AJ0E38GKHXS8ADN8T1T
created: 2026-08-17T16:16:33.856545Z
updated: 2026-08-17T16:16:33.856545Z
type: task
title: Access Control inception + ADR 0045
label: brief
assignee: steve
task_status: todo
priority: high
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 235
---
A genuinely new domain area — nothing in the briefs or ADRs models it — so, per the convention established by 0021/0023/0024/0025 and the shape proven by ADR 0039 (vendors): **one full-domain ADR now, schema landing incrementally with each task**.

ADR 0045 must settle:

* **Vocabulary.** Three meanings of "role" now collide: Compass app roles (ADR 0026), the matrix's **business roles**, and Entra directory roles. Pin distinct names in code and UI before the first migration (working names: `business_role` for the matrix; "role" unqualified stays ADR 0026's). Likewise "user": ADR 0007's Compass users vs the Entra **directory users** this feature governs — two identity domains, say so explicitly.
* **Entity model.** Connection settings singleton; directory mirror (users/groups/memberships); company-scoped `business_roles` + role↔group mappings; JML request with a module-level allowed-transitions map (ADR 0039 §2 — no state-machine engine); recert campaigns + review items, with membership snapshotted at campaign open (the ADR 0015 §4 revision pattern — "what did this look like last quarter" is the audit question).
* **Blast radius + maker-checker.** ADR 0034 accepted "app identity exceeds user identity" at read scope (`Sites.Selected`); at `User.ReadWrite.All`/`Group.ReadWrite.All` it is a privilege-escalation path. Record the mitigation: no Graph write without a second person's approval; exact permission list; excluded/protected groups (e.g. privileged directory roles) Compass refuses to manage.
* **Tenancy.** Global tenant connection (the `m365_settings`/ADR 0044 §1 precedent), company-scoped governance data (the vendors precedent).
* **IA (ADR 0017).** Connection config lives in Admin ▸ Integrations beside M365 and Email; the role matrix / JML / recert screens are a new role-gated **Access** nav section (the ADR 0039/0040 sectioning precedent).

Decisions already settled at sprint planning (2026-08-17) are recorded on the sprint description — carry them into the ADR, don't re-open them.