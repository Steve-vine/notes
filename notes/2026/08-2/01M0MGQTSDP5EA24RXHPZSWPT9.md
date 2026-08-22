---
id: 01M0MGQTSDP5EA24RXHPZSWPT9
created: 2026-08-22T10:37:22.093541Z
updated: 2026-08-22T14:02:54.529481Z
type: task
title: Vendor detail Assessments tab — applicable assessments, Assign button, completed history
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 355
sprint: sbph5q5
blocked_by:
- 01M0MFZ5YKBJZ84F0MV1FX8CJC
comments:
- id: 01M0MWFBCGKB1D49K3AHVGG6NR
  author: Steve Vine
  at: 2026-08-22T14:02:27.087846Z
  text: |-
    Done — PR #358.

    An **Assessments** tab between Details and Reviews. (The ask said "between Details and Findings"; findings live inside Reviews, so this is that position — a separate Findings tab is its own conversation.) `AssessmentsCard` **moves** into it: one home, not two, and a test pins that it left Details.

    **Two groups.** Outstanding mixes two things that are the same job from a reader's side — forms the rules require that nobody has assigned (each with **Assign**), and assessments already awaiting completion. Completed below, opening to the read-only record. `closed` (COM-356) counts as finished alongside `completed`.

    The required-but-not-assigned rows **have no assessment**, which is why they need their own endpoint rather than a marker folded into the assessments list: they cannot ride on a list of things that exist.

    **The vendor-level question.** The rules judge an *engagement* deliberately (COM-208), so `required_form_ids_for_vendor` takes the union across the vendor's live engagements — a supplier doing two jobs for us owes whatever either job calls for. Ended engagements excluded (finished work cannot justify asking for anything new); proposed ones included (a relationship being set up is exactly when its assurance is worth collecting).

    **`outstanding` compares against live assessments, never history** — a completed copy from last year must not suppress this year's ask, since re-running is the designed way to re-assess (COM-190). Made server-side, because it is the same question the rules answer.

    Two details worth recording:
    - Retired forms are reported with `active: false` rather than dropped. A rule set requiring a since-retired form is a misconfiguration worth *seeing*; the tab says why it cannot be assigned instead of leaving a silent gap.
    - The hook is **disabled in the portal at source**, not merely documented as internal. `AssessmentsCard` is shared and renders in the employee portal, whose contract is that it never touches an internal endpoint (ADR 0040 §2) — `PortalVendorDetailPage`'s own "never the internal vendor API" test caught this, and was right to.
- id: 01M0MWG6615B19X0T86Y6G0XGW
  author: Steve Vine
  at: 2026-08-22T14:02:54.528867Z
  text: |-
    Done — PR #358.

    An **Assessments** tab between Details and Reviews. (The ask said "between Details and Findings"; findings live inside Reviews, so this is that position — a separate Findings tab is its own conversation.) `AssessmentsCard` **moves** into it: one home, not two, and a test pins that it left Details.

    **Two groups.** Outstanding mixes two things that are the same job from a reader's side — forms the rules require that nobody has assigned (each with **Assign**), and assessments already awaiting completion. Completed below, opening to the read-only record. `closed` (COM-356) counts as finished alongside `completed`.

    The required-but-not-assigned rows **have no assessment**, which is why they need their own endpoint rather than a marker folded into the assessments list: they cannot ride on a list of things that exist.

    **The vendor-level question.** The rules judge an *engagement* deliberately (COM-208), so `required_form_ids_for_vendor` takes the union across the vendor's live engagements — a supplier doing two jobs for us owes whatever either job calls for. Ended engagements excluded (finished work cannot justify asking for anything new); proposed ones included (a relationship being set up is exactly when its assurance is worth collecting).

    **`outstanding` compares against live assessments, never history** — a completed copy from last year must not suppress this year's ask, since re-running is the designed way to re-assess (COM-190). Made server-side, because it is the same question the rules answer.

    Two details worth recording:
    - Retired forms are reported with `active: false` rather than dropped. A rule set requiring a since-retired form is a misconfiguration worth *seeing*; the tab says why it cannot be assigned instead of leaving a silent gap.
    - The hook is **disabled in the portal at source**, not merely documented as internal. `AssessmentsCard` is shared and renders in the employee portal, whose contract is that it never touches an internal endpoint (ADR 0040 §2) — `PortalVendorDetailPage`'s own "never the internal vendor API" test caught this, and was right to.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
On the admin vendor detail page (`VendorDetailPage.tsx`), add an **Assessments** tab. The ask said "between Details and Findings" — the current tabs are Details / Reviews / History with findings living inside Reviews, so it goes **between Details and Reviews**; if a separate Findings tab was intended that's its own conversation.

## What the tab shows

Everything that *applies* to this vendor, in two groups:

- [ ] **Uncompleted, at the top.** Two kinds in one group: assessments the Assessment Rules (COM-354's evaluation) say this vendor requires but which have **not been assigned** — each with an **Assign** button that creates the open (`pending`) `VendorAssessment` (the existing `POST /vendors/{id}/assessments` with that form) — and assessments already open on the vendor (assigned, awaiting completion, no button).
- [ ] **Completed, below**, with `completed_at` shown; each opens to the read-only record (the snapshotted prompts + answers via the existing detail endpoint).
- [ ] A form can appear in both groups (completed once, required again for a re-run) — the top group's "required but not assigned" check compares against *open* assessments, not against history, since re-runs are the designed path ("add the assessment again for a re-run", COM-190).

## Mechanics

- [ ] The existing `AssessmentsCard` currently renders inside the Details tab — it **moves** into the new tab (one home, not two); Details slims down accordingly.
- [ ] Backend: probably just one addition — a way to ask "which forms do the assessment rules require for this vendor?" (COM-354's evaluation exposed on the vendor read path, e.g. folded into the assessments list response with a `required`/`source` marker) — assign/complete/read all exist.
- [ ] Gating as today: reads on vendor read; Assign on vendor write (`canEdit`).
- [ ] Tests: grouping and ordering; Assign creates a pending assessment and the row moves groups; a rule-required form already open shows no button; completed rows show dates and open read-only; re-run case renders in both groups.