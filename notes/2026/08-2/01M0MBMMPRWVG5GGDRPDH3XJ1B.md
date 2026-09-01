---
id: 01M0MBMMPRWVG5GGDRPDH3XJ1B
created: 2026-08-22T09:08:14.680454Z
updated: 2026-09-01T13:55:51.380786Z
type: task
title: 'ADR: consolidate the vendor roles to vendor_admin / vendor_approver / vendor_user'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 344
sprint: sbph5q5
comments:
- id: 01M0MCK1YP5VNMJE33D2345HVF
  author: Steve Vine
  at: 2026-08-22T09:24:51.28642Z
  text: |-
    Done — `decisions/0049-vendor-roles-admin-approver-user.md`, merged as #346 (183f987).

    Three roles on one axis (which door do you come in by): `vendor_admin` runs the internal Vendors section, `vendor_approver` decides from the user portal, `vendor_user` views/requests/owns. The four old roles are removed outright, enum members included — a forward rebuild of `user_role`, which is only possible because nothing is live, and the ADR says so in §4 so it isn't read as a precedent.

    One thing worth flagging beyond the ticket: **ADR 0043 (2026-08-16) already answered this question** and was accepted but never implemented. It kept two roles and removed `_VENDOR_ASSESS` entirely, making the `vendor_approvers` row the sole gate on deciding. 0049 supersedes it and argues the point in §5 and in Alternatives: 0043's design makes a reference-data edit the whole of a permission grant and takes "who can decide?" off the Users screen. 0043's own alternatives section rejected auto-granting the role as "two facts with extra steps" — §5 is that design, and the extra step is one INSERT in a handler that was already writing rows. 0043 is marked `Superseded by: 0049`; its ownership-is-a-relationship argument survives and is restated in §6.

    All four ticket checkboxes recorded: no self-approval (§7), viewer unchanged (§1 table), old roles removed outright (§1, §4), supersessions in the header.
assignee: steve
label:
- chore
priority: medium
task_status: done
---
The current model (ADR 0039 §8 + ADR 0040 §1) spreads vendor work across four roles — `vendor_owner`, `vendor_manager`, `vendor_assessor`, `vendor_portal` — with capability sets that overlap awkwardly: managers administer the approval machinery but can't decide; assessors decide but can't read the internal register; owners and portal users differ only in register read; and both the approver lists and the ownership records can name people who hold no role that lets them act ("listed but can't decide" — COM-225's warning marker; the stranded-owner gap).

New model, making **"which portal do you live in?" the primary axis**:

- **`vendor_admin`** — the whole admin-portal Vendors section, all actions, including deciding approvals. Must still be **listed on an approval area** to decide it (only global `admin` bypasses membership). May edit the approver lists but cannot decide an area not assigned to them — the audit log is the mitigation for self-assignment.
- **`vendor_approver`** — decides the areas assigned to them, from a new **Requests section in the user portal**. No admin-portal access. Auto-granted/revoked via the area approver lists (see follow-on task).
- **`vendor_user`** — user portal only: view vendors, request new ones, be an owner/co-owner. Granted to most staff but deliberately not universal; ownership targets must hold a qualifying role (see follow-on task).

Cross-cutting decisions to record:

- [ ] **No self-approval**: a request's submitter cannot decide its approvals; global `admin` is exempt, mitigated by the audit log.
- [ ] `viewer` keeps app-wide read-only access, including the vendor register — that role is app-wide, not vendor-specific.
- [ ] The four old roles are **removed outright** (forward enum rebuild). Compass is not live; no backward compatibility.
- [ ] Supersedes ADR 0039 §8; amends/supersedes ADR 0040 §1's role. Append-only `decisions/NNNN-*.md`.