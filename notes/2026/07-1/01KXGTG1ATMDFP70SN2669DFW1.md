---
id: 01KXGTG1ATMDFP70SN2669DFW1
created: 2026-07-14T17:23:49.210591418Z
updated: 2026-07-14T17:23:56.946414984Z
type: task
title: Move domain/control disable & delete off the list views
task_status: done
label:
- brief
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 86
sprint: s114vjm
comments:
- id: 01KXGTG8WJMJEFSE9Z654VY3SN
  author: Steve Vine
  at: 2026-07-14T17:23:56.946299014Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-25 20:15 UTC]
    Done — PR [#78](https://github.com/Steve-vine/compass/pull/78), branch `steve/dev-637-move-domain-control-actions-off-lists`.

    Removed the Actions column from DomainsPage, ControlsPage, and the controls table on DomainDetailPage; disable/delete remain on the individual DomainDetailPage / ControlDetailPage headers. Status badges stay on the lists (read-only). No backend change; typecheck/eslint/prettier clean, affected page tests pass.

    Moving to In Review. DEV-636 (domain code + auto-refs) will be sequenced on top once this merges.
---
M18 follow-up (frontend only). The disable/enable + delete row actions are currently on the **list** views; move them so they live **only on the individual detail pages**, reducing accidental destructive actions from the browse lists.

### Checklist

- [ ] **DomainsPage**: remove the **Actions** column (`DomainActionButtons`) from the domains table. Keep "New domain" and the show-disabled toggle. Domain disable/delete stays on `DomainDetailPage` (already in the header).
- [ ] **ControlsPage**: remove the **Actions** column (`ControlActionButtons`) from the controls table. Keep "New control" and the show-disabled toggle. Control disable/delete stays on `ControlDetailPage` (already in the header).
- [ ] **DomainDetailPage controls table**: also remove the per-control Actions column there (it's a control *list*); per-control disable/delete belongs on each `ControlDetailPage`. Keep the "Add control" affordance.
- [ ] Status badges stay on all the lists (read-only).

No backend change. Sequence vs the domain-code brief (both touch the same pages) — "sequence, don't stack".

Refs: ADR 0027, <issue id="220efae1-6e5a-4bf8-9a0c-92497299951b" href="https://linear.app/stevevine/issue/DEV-629/frontend-domain-and-control-editing-control-detail-page">DEV-629</issue>.

---
*Migrated from Linear [DEV-637](https://linear.app/stevevine/issue/DEV-637/move-domaincontrol-disable-and-delete-off-the-list-views) · created 2026-06-25 · completed 2026-06-25*  
*Related to (Linear): DEV-636, DEV-629*